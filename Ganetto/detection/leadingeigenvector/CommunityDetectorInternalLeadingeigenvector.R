###############################################################################
## This class implements the Leading Eigen-Vector hierarchical algorithm, as
## defined by Newman:
##		- Newman, M. E. J. 
##		  Finding community structure in networks using the eigenvectors of matrices 
##		  Physical Review E, 2006, 74, 036104.
##
## Parameters: 
##	- none interesting
## Input:
##	- iGraph network
## 	- weighted or unweighted
##	- undirected
##  - the network must be connected (i.e. no more than one component)
## Output:
##	- dendrogram (R object)
##	- mutually exclusive communities
## Use:
## 	- it is implemented in iGraph, so its use is standard
## 
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalLeadingeigenvector <- setRefClass("CommunityDetectorInternalLeadingeigenvector",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "LEADING_EIGENVECTOR"
			fileName <<- "leadingeigenvector"
			plotText <<- "LeadingEigenVector"

#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be undirected, but it can be weighted or unweighted.
		## The network must be connected (i.e. no more than one weakly
		## connected component)
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
			temp <- leading.eigenvector.community(graph=network)
			
			# convert to a Comstruct list
			result <- dendrogramToComstructList(network=network,
				dendrogram=temp$merges, evMembership=temp$membership)
			# reverse it because the algorithm is divisive
			result <- rev(result)
			
			return(result)
		}
	)
)
