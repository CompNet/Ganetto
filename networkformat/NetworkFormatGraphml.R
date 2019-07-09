###############################################################################
## This class load/records a network under the form of a graphml file. 
## 
## It relies completely on igraph, so please see the igraph documentation 
## for further details. 
## 
## This format allows representing pretty much any kind of graph. Cf. igraph
## documentation to see if it supports all graphml features.
##
## @author Vincent Labatut
## @version 3
###############################################################################

NetworkFormatGraphml <- setRefClass("NetworkFormatGraphml",
	contains = "NetworkFormat",
	methods = list(
		readNetwork = function(fullPath)
		{	# just use igraph to load the graph
			network <- read.graph(file=fullPath,format="graphml")
			
			# possibly remove/add weights/directions
			network <- cleanNetwork(network)
			
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
			#print(is.directed(network))
			
			# use igraph to record the file
			write.graph(graph=network,file=fullPath,format="graphml")
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(".graphml")
		}
	)
)
