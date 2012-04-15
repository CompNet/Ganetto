###############################################################################
## This class implements the Fast Greedy hierarchical algorithm as defined by Newman:
##	- Newman, M. E. J. 
##	  Fast algorithm for detecting community structure in networks
##	  Physical Review E, 2004, 69, 066133.
##	- Clauset, A.; Newman, M. E. J. & Moore, C.
##	  Finding community structure in very large networks
##	  Physical Review E, 2004, 70, 066111.
##
## Parameters: 
##	- none
## Input:
##	- iGraph network
## 	- weighted or unweighted
##	- undirected
## Output:
##	- dendrogram (R object)
##	- mutually exclusive communities
## Use:
## 	- It is implemented in iGraph, so its use is standard
## 
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalFastgreedy <- setRefClass("CommunityDetectorInternalFastgreedy",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "FAST_GREEDY"
			fileName <<- "fastgreedy"
			plotText <<- "FastGreedy"

#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be undirected, but it can be weighted or unweighted.
		## The network must be simple, i.e. no loops (self-links) and multiple links
		## (several links between the same nodes).
		##
		## @param network
		##		The network to be processed.
		## @param baseFolder
		##		Not used in internal algorithms (only external ones).
		## @param considerWeights
		##		Whether or not weights should be used while detecting communities.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder, 
			considerWeights)
		{	# the network must be undirected
			network <- adaptNetworkDirections(network=network, wantsDirections=FALSE)
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
						
			# apply the algorithm and get the dendrogram as a merge matrix
			mergeMatrix <- fastgreedy.community(graph=network, 
					merges=TRUE, modularity=TRUE)$merges
			# modularity=FALSE prevents the program from processing modularities for every possible cut,
			# so it's supposed to be faster. But it also causes bugs sometimes, so we set it to TRUE.
			
			# convert to a Comstruct list
			result <- dendrogramToComstructList(network=network,
				dendrogram=mergeMatrix)
			
			return(result)
		}
	)
)
