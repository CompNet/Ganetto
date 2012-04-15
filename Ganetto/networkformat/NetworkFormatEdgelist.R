###############################################################################
## This class load/records a network under the form of a file,
## whose each line represents a link. The link is described by the ids
## of the source and target nodes, and possibly a weight, all space-separated.
## The order of the node ids is considered only if the network is supposed
## to be directed.
##
## This implementation relies on igraph for unweighted networks, but there seem
## to have bugs when there are weights, so in this case a custom process is performed. 
## 
## This format allows to represent (un)directed, (un)weighted, multiple, links,
## but no fancy stuff such as nodal attributes, other relational attributes,
## hypernetworks, etc. It is not possible neither to represent isolates, since
## a node whose degree is zero will not appear in any link.
##
## @author Vincent Labatut
## @version 3
###############################################################################

NetworkFormatEdgelist <- setRefClass("NetworkFormatEdgelist",
	contains = "NetworkFormat",
	
	methods = list(
		## Reads a network from a file.
		## If the directed/weighted fields are defined,
		## the read network might be modified accordingly.
		##
		## @param fullPath
		##		The path of the file to be read.
		## @returns
		##		An igraph object corresponding to the data read.
		readNetwork = function(fullPath)
		{	# read the file as a table
			table <- read.table(file=fullPath)
			# retrieve the edgelist as a matrix
			edgeMatrix <- matrix(ncol=2,nrow=nrow(table))
			edgeMatrix[,1] <- table$V1
			edgeMatrix[,2] <- table$V2
			
			# build the network
			if(length(directed)==0 || is.na(directed))
				dtd <- FALSE
			else
				dtd <- directed
			network <- graph.edgelist(el=edgeMatrix, directed=dtd)
			
			# possibly set the weights
			if(ncol(table)==3 && (length(weighted)==0 || is.na(weighted) || weighted))
				E(network)$weight <- table$V3
			else
			{	if(length(weighted)>0 && !is.na(weighted) && weighted)
				{	E(network)$weight <- 1
					warning(paste("NetworkFormatEdgelist$readNetwork: The network is not originally weighted: weights set to 1 at your demand (",fullPath,").",sep=""))
				}
			}
			
			# set the id attribute
			network <- initNodeIds(network)
			
			return(network)
		},
				
		## Writes a network in a file.
		## If the directed/weighted fields are defined,
		## then the read network might be temporarily modified accordingly.
		##
		## @param network
		##		The igraph object to be written.
		## @param fullPath
		##		The path of the file to be written.
		writeNetwork = function(network, fullPath)
		{	# possibly create the needed folders
			checkParentFolder(fullPath)
			
			# possibly remove/add weights/directions
			network <- cleanNetwork(network)
			
			# for graphs both undirected and unweighted, we can use igraph
			if(!is.weighted(network) && !is.directed(network))
			{	write.graph(graph=network, file=fullPath, format="edgelist")
			}
			
			# for the others, it must be saved manually
			else
			{	if(is.weighted(network))
				{	m <- matrix(NA, nrow=ecount(network), ncol=3)
					m[,3] <- E(network)$weight
				}
				else
					m <- matrix(NA, nrow=ecount(network), ncol=2)
				m[,1:2] <- get.edgelist(network)
				table <- as.table(m)
				#cat("table:",dim(table)," ecount:",ecount(g),"\n")			
				write.table(table, file=fullPath,
					quote=FALSE, row.names=FALSE, col.names=FALSE)
			}
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(".edgelist")
		}
	)
)
