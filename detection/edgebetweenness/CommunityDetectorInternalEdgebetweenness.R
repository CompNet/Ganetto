###############################################################################
## This class implements the Edge-Betweenness hierarchical algorithm, as defined
## by Newman & Girvan:
##		- Newman, M. E. J. & Girvan, M. 
##		  Finding and evaluating community structure in networks.
##		  Physical Review E, 2004, 69, 026113.
##
## Parameters: 
##	- none
## Input:
##	- iGraph network
## 	- unweighted
##	- directed or undirected
## Output:
##	- dendrogram (R object)
##	- mutually exclusive communities
## Use:
##	- It is implemented in iGraph, so its use is standard
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalEdgebetweenness <- setRefClass("CommunityDetectorInternalEdgebetweenness",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "EDGE_BETWEENNESS"
			fileName <<- "edgebetweenness"
			plotText <<- "EdgeBetweenness"

#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be unweighted, but it can be directed or undirected.
		##
		## @param network
		##		The network to be processed.
		## @param baseFolder
		##		Not used in internal algorithms (only external ones).
		## @param considerDirections
		##		Whether or not directions should be used while detecting communities.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder, 
			considerDirections)
		{	# an argument of the algorithm allows considering/ignoring directions
			
			# weights are always ignored by this algorithm
			
			# apply the algorithm and get the dendrogram as a merge matrix
			mergeMatrix <- edge.betweenness.community(graph=network, 
					directed=considerDirections,
					edge.betweenness=FALSE, merges=TRUE, bridges=FALSE,
					labels=FALSE)$merges
			
			# convert to a Comstruct list
			result <- dendrogramToComstructList(network=network,
				dendrogram=mergeMatrix)
			# reverse it because the algorithm is divisive
			result <- rev(result)
		
			return(result)
		}
	)
)
