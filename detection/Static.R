###############################################################################
## This file contains several functions considered as static relatively to the
## CommunityDetectiorXxxxx classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

## Applies a set of community detection algorithms to the network 
## represented by the leaf. Note some algorithms might be configured 
## to use several combinations of parameter values.
## 
## The detected communty structures are recorded using the 
## algorithms parameters.
## 
## @param leaf
##		The Parameter object used to get the network.
## @algorithms
##		A list of CommunityDetector objects.
applyAlgorithmsToParameterTree <- function(leaf, algorithms)
{	# load the network
	basePath <- leaf$getFullPath()
	networkInFormat <- algorithms[[1]]$networkInFormat
	fullPath <- networkInFormat$completeFullPath(fullPath=basePath,
		folderCheck=TRUE, extCheck=TRUE)
	network <- networkInFormat$readNetwork(fullPath)
	
	# apply the algorithms
	lapply(algorithms, function(algo)
		{	# TODO set log
			cat("....applying algorithm '",algo$plotText,"'\n",sep="")
			algo$applyAlgorithmToParameterTree(leaf=leaf, network=network)
		}
	)
}
