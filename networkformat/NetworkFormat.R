###############################################################################
## This abstract class in is in charge of loading/recording networks.
## Each different format must take the form of a new class iheriting this one.
##
## @author Vincent Labatut
## @version 3
###############################################################################

NetworkFormat <- setRefClass("NetworkFormat",
	fields = list(
		## Indicates whether this network should be considered as directed.
		## When loading, if the file does not correspond to this parameter,
		## the loaded object will be adapted accordingly by creating/removing
		## directions. When recording, if the considered object does not
		## correspond, it will be temporarilly modified and then recorded.
		## Directions are created from an undirected network by considering
		## all undirected links as bidirectional. Undirected links are obtained
		## by merging bidirectional relationships in order to avoid multiple links.
		directed="logical",
		
		## Indicates whether this network should be considered as weigthed.
		## When loading, if the file does not correspond to this parameter,
		## the loaded object will be adapted accordingly by creating/removing
		## weights. When recording, if the considered object does not
		## correspond, it will be temporarilly modified and then recorded.
		## Weights are created from an unweighted network by artificially
		## introducing a new attribute whose value is 1 for all links. 
		## Unweighted links are obtained by just ignoring the existing weights.
		weighted="logical"
	),
	
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
		{	return(NA)
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
		{	return(NA)
		},
		
		## Helper method forcing the specified network to be 
		## (un)directed/(un)weighted depending on the directed/weighted fields.
		##
		## @param
		## 		The network to be modified.
		## @returns
		##		The modified version of the network.
		cleanNetwork = function(network)
		{	# deal with weights
			if(length(weighted)>0 && !is.na(weighted))
				network <- adaptNetworkWeights(network,weighted)
			
			# deal with directions
			if(length(directed)>0 && !is.na(directed))
				network <- adaptNetworkDirections(network,directed)
			
			return(network)
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(NULL)
		},
		
		## Complete the specified file path, in case it points at a folder,
		## or the file extension is missing/inappropriate. Both conditions
		## can be handled independtly.
		##
		## @param fullPath
		##		The path to be completed.
		## @param folderCheck
		##		If TRUE, the existence of the folder containing the file will
		##		be tested, and the folder will be created if needed.
		## @param extCheck
		##		If TRUE, the end of the path will be checked, and will be
		## 		appended with an appropriate extension if it is not already present.
		completeFullPath = function(fullPath, folderCheck=TRUE, extCheck=TRUE, 
				directedVersion, weightedVersion)
		{	result <- fullPath
			
			# if the path points at a folder: add the file name
			if(folderCheck)
			{	if(file.exists(result) && file.info(result)$isdir)
					result <- paste(result,"/network",sep="")
			}
			
			# possibly complete appropriately the file name
			if(!missing(directedVersion))
			{	if(directedVersion)
					result <- paste(result,".directed",sep="")
				else
					result <- paste(result,".undirected",sep="")
			}
			if(!missing(weightedVersion))
			{	if(weightedVersion)
					result <- paste(result,".weighted",sep="")
				else
					result <- paste(result,".unweighted",sep="")
			}
			
			# if the file extension is not appropriate, add one
			if(extCheck)
			{	observedExt <- getFileExtension(result)
				targetExt <- getFileExt()
				if(is.null(observedExt) || observedExt!=targetExt)
					result <- paste(result,targetExt,sep="")
			}
			
			return(result)
		},
		
		## Initializes the nodal attribute 'id' so that
		## it corresponds to the node number. This can
		## be used when dealing with subgraphs and still
		## wanting to identify the node relatively to the
		## whole network.
		## 
		## @param network
		##		The original network.
		## @return
		##		The completed network.
		setNodeIds = function(network)
		{	if(is.null(V(network)$id))
				V(network)$id <- 0:(vcount(network)-1)
			return(network)
		}
	)
)

# load related files
source("Ganetto/networkformat/NetworkFormatEdgelist.R")
source("Ganetto/networkformat/NetworkFormatGraphml.R")
source("Ganetto/networkformat/NetworkFormatNodelist.R")
source("Ganetto/networkformat/NetworkFormatPajek.R")
