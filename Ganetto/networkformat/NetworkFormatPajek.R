###############################################################################
## This class load/records a network under the form of a file,
## using the simplest pajek format for network representation. 
##
## This implementation relies completely on igraph, please see its documentation
## for any further detail.
## 
## This format allows to represent (un)directed, unweighted, networks. Not all 
## pajek features are implemented by igraph, see the appropriate documentation.
##
## @author Vincent Labatut
## @version 3
###############################################################################

NetworkFormatPajek <- setRefClass("NetworkFormatPajek",
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
		{	# here, we just use igraph
			network <- read.graph(file=fullPath,format="pajek")
			
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
			
			# record simply using igraph
			write.graph(graph=network,file=fullPath,format="pajek")
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(".net")
		}
	)
)
