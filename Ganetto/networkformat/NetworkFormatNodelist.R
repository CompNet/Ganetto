###############################################################################
## This class load/records a network under the form of a file,
## whose each line represents the neighborhood of a node. The first id on
## the line is the node of interest, all the rest are the nodes connected to it
## through links going from the node to the neighbor. The direction is considered
## only when the class parameters are appropraite (cf. NetworkFormat). 
##
## This implementation is completely custom. 
## 
## This format allows to represent (un)directed, unweighted, multiple, links only.
##
## @author Vincent Labatut
## @version 3
###############################################################################

NetworkFormatNodelist <- setRefClass("NetworkFormatNodelist",
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
		{	# init
			bufferSize <- 1000
			srcs <- c()
			dsts <- c()
			connection <- file(fullPath,"r")
				
			# load paquets of lines
			while(length(input <- readLines(con=connection,n=bufferSize))>0)
			{	# process each line separately
				for(i in 1:length(input))
				{	line <- input[[i]]
					# we ignore comments: line starting by '#'
					if(substr(line,1,1) != "#")
					{	# split the line using spaces
						temp <- sapply(strsplit(line," ")[[1]], as.numeric)
						src <- temp[1]
						
						if(length(temp)>1)
						{	# process each element in the line separately
							for(t in 2:length(temp))
							{	dst <- temp[t]
								# add the source and destination nodes to the vectors
								srcs <- c(srcs,src)
								dsts <- c(dsts,dst)
							}
						}
					}
				}
			}
			close(connection)
			
			# build the edgelist matrix
			edgeMatrix <- cbind(srcs,dsts)
			dtd <- length(directed)>0 && !is.na(directed) && directed
			network <- graph.edgelist(el=edgeMatrix,directed=dtd)

			# possibly add weights
			if(length(weighted)>0 && !is.na(weighted) && weighted)
			{	warning(paste("NetworkFormatNodelist$readNetwork: The network is not originally weighted: weights set to 1 at your demand (",fullPath,").",sep=""))
				network <- set.edge.attribute(graph=network, name="weight", index=E(network), value=1)
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
			
			# get neighborhoods
			if(is.directed(network))
				mode <- "out"
			else
				mode <- "all"
			neighborhoods <- neighborhood(graph=network, order=1, 
					nodes=V(network), mode=mode)

			# record some metadata
			connection <- file(fullPath,"w")
			cat("# File created on ",format(Sys.time(),"%a %b %d %X %Y"), "\n",sep="",file=connection)
			cat("# by Ganetto v",GANETTO_VERSION,"\n",sep="",file=connection)
			if(is.directed(network)) 
				dStr <- "directed" 
			else 
				dStr <- "undirected"
			cat("# links are unweighted and ",dStr,"\n",sep="",file=connection)
			cat("##########################################\n",sep="",file=connection)
			
			# record the node lists
			sapply(neighborhoods, function(neigh)
			{	if(!is.directed(network))
					neigh <- neigh[neigh>=neigh[1]]
				text <- paste(neigh, collapse=" ")				
				cat(text, "\n", sep="", file=connection)
			})
			close(connection)
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(".nodelist")
		}
	)
)
