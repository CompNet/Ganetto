###############################################################################
## This class implements the Label Propagation algorithm, as defined in:
##	- Raghavan, U. N.; Albert, R. & Kumara, S.
##	  Near linear time algorithm to detect community structures in large-scale networks
##	  Physical Review E, 2007, 76, 036106.
##
## Parameters: 
##	- none
## Input:
##	- iGraph network
## 	- weighted or unweighted
##	- undirected
## Output:
##	- Dendrogram (R object)
##	- Mutually exclusive communities
## Use:
## - It is implemented in iGraph, so its use is standard
## 
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalLabelpropagation <- setRefClass("CommunityDetectorInternalLabelpropagation",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "LABEL_PROPAGATION"
			fileName <<- "labelpropagation"
			plotText <<- "LabelPropagation"

#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be undirected, but it can be weighted or unweighted.
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
		{	# link directions are always ignored
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# apply the algorithm and get the partition representing the community structure
			partition <- label.propagation.community (graph=network)
						
			# convert to a Comstruct list
			result <- list(partitionToComstruct(partition))
			
			return(result)
		}
	)
)
