###############################################################################
## This class implements the Walk Trap algorithm as described by Pons & Latapy:
##	- Pons, P. & Latapy, M. 
##	  Computing communities in large networks using random walks 
##	  International Conference on Computer and Information Sciences, 2005, 3733, 284-293.
##
## Parameters:
##	- steps: the length of the random walk, which has an effect on the community granularity.
## Input:
##	- iGraph network
## 	- weighted or unweighted
##	- undirected or directed
##  - cannot process isolated nodes, which are therefore removed by this script.
## Output:
##	- Mutually exclusive communities
##	- Dendrogram (R object)
## Use:
## 	- It is implemented in iGraph, so its use is standard
##	- Note: also available as C++ code at: http://www-rp.lip6.fr/~latapy/PP/walktrap.html
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalWalktrap <- setRefClass("CommunityDetectorInternalWalktrap",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "WALK_TRAP"
			fileName <<- "walktrap"
			plotText <<- "WalkTrap"

#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be undirected, but it can be weighted or unweighted.
		##
		## @param network
		##		The network to be processed.
		## @param baseFolder
		##		Not used in internal algorithms (only external ones).
		## @param considerDirections
		##		Whether or not directions should be used while detecting communities.
		## @param considerWeights
		##		Whether or not weights should be used while detecting communities.
		## @param steps
		##		Length of the random walk used to detect communities.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder, 
				considerDirections, considerWeights, 
				steps=4)
		{	# checks if directions should be ignored
			network <- adaptNetworkDirections(network=network, wantsDirections=considerDirections)
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# this algo does not handle isolated nodes, so they must be removed before applying it
			deg <- degree(graph=network, v=V(network), mode="all", loops=FALSE)
			g <- subgraph(graph=network, v=(0:(vcount(network)-1))[deg>0])
			
			# apply the algorithm and get the dendrogram as a merge matrix
			mergeMatrix <- walktrap.community(graph=g, steps=steps, 
				merges=TRUE, modularity=TRUE, labels=TRUE)$merges
			# modularity=FALSE prevents the program from processing modularities for every possible cut,
			# so it's supposed to be faster. But it also causes bugs sometimes, so we set it to TRUE.
			
			# convert to a Comstruct list
			result <- dendrogramToComstructList(network=g,
				dendrogram=mergeMatrix)
			
			# complete it by putting back the isolates
			for(c in 1:length(result))
			{	comstruct <- result[[c]]
				indices <- (0:(length(deg)-1))[deg==0]
				for(i in indices)
					comstruct$insertNode(i)
				result[[c]] <- comstruct
			}
		
			return(result)
		}
	)
)
