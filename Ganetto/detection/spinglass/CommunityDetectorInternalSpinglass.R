###############################################################################
## This class implements the SpinGlass algorithm, i.e. find communities via 
## simulated annealing optimization as described in:
##	- Reichardt, J. & Bornholdt, S. 
##	  Statistical mechanics of community detection 
## 	  Physical Review E, 2006, 74, 016110.
##
## Parameters:
##	- spins: number of spins to use, i.e. the upper limit for the number of communities
##			 this value must be smaller or equal to 500.
##	- update.rule: null model c("config","random","simple")
##			"simple" uses a random graph with the same number of edges as the baseline probability,
##			"config" uses a random graph with the same vertex degrees as the input graph.
##	- gamma: This specifies the balance between the importance of present and non-present edges 
##			 in a community. Roughly, a comunity is a set of vertices having many edges inside 
##			 the community and few edges outside the community. The default 1.0 value makes existing 
##			 and non-existing links equally important. Smaller values make the existing links, 
##			 greater values the missing links more important.
##  - other temperature-related parameters.
##
## Input: 
##	- iGraph network
## 	- weighted or unweighted 
##	- undirected
##	- the network must be connected. If there are several components,
##	  the script will process them separately and merge the results to get
##	  the global membership vector. Of course, in this case, one community
##	  cannot span accross several components.
## Output:
##	- Mutually exclusive communities
##	- Multiresolution approach thanks to the spins parameter
##	- An R vector
## Use:
## 	- It is implemented in iGraph, so its use is standard
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternalSpinglass <- setRefClass("CommunityDetectorInternalSpinglass",
	contains = "CommunityDetectorInternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			
			internalName <<- "SPIN_GLASS"
			fileName <<- "spinglass"
			plotText <<- "SpinGlass"

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
		## @param spins
		##		Maximal number of communities allowed when detecting communities.
		##		This value must be smaller or equal to 500.
		## @param parupdate
		##		Parallel update of the spins.
		## @param start.temp / stop.temp
		##		Start and stop temperatures for the simulated annealing.
		## @param cool.fact
		##		Cooling factor for the simulated annealing.
		## @param update.rule
		##		Null model of the simulation: config, random or simple.
		## @param gamma
		##		Specifies the relative importance of present/absent links.
		##		1 is balances, <1 makes the missing links more important,
		##		>1 makes the existing links more important.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder, 
			considerWeights, 
			spins, parupdate=FALSE, start.temp=1, stop.temp=0.01, cool.fact=0.99, 
			update.rule="config", gamma=1)
		{	# by default, we allow as many communities as there're nodes
			if(missing(spins))
				spins <- min(500,vcount(network))
			
			# link directions are always ignored
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# for disconnected networks, each component must be processed separately
			# this requires a specific process: we consider the components as a first
			# hierarchical level of community structure, and the algorithm is then 
			# applied to each component separately, in order to get a second level.
			result <- list()
			V(network)$id <- 1:vcount(network)
			components <- decompose.graph(graph=network,mode="weak")
			
			# only one component
			if(length(components)==1)
			{	partition <- spinglass.community(graph=network,
					spins=spins, parupdate=parupdate, 
					start.temp=start.temp, stop.temp=stop.temp, cool.fact=cool.fact, 
					update.rule=update.rule, gamma=gamma
				)$membership
				comstruct <- partitionToComstruct(partition)
				result[[1]] <- comstruct
			}
				
			# several components
			else
			{	# create the first hierarchical level (components)
				partition <- rep(NA,vcount(network))
				for(c in 1:length(components))
					partition[V(components[[c]])$id] <- c
				comstruct <- partitionToComstruct(partition)
				result[[1]] <- comstruct
				
				# processing each component separately to get the second hierarchical level
				partition <- rep(NA,vcount(network))
				for(c in 1:length(components))
				{	# This algo can only process components containing more than 20 nodes.
					# If there's less, it just takes forever. Seems to be a bug.
					# note: value experimentaly determined, might be changed if needed 
					if(vcount(components[[c]])>20)
					{	# apply the algorithm
						temp <- spinglass.community(graph=components[[c]],
							spins=min(spins,vcount(components[[c]])), parupdate=parupdate, 
							start.temp=start.temp, stop.temp=stop.temp, cool.fact=cool.fact, 
							update.rule=update.rule, gamma=gamma
						)$membership
					}
					else
					# else, we suppose all the components nodes form a single community
						temp <- rep(1,vcount(components[[c]]))
					
					# merge with the existing membership vector
					if(min(temp,na.rm=TRUE)==0)
						temp <- temp + 1
					maxCom <- max(c(0,partition),na.rm=TRUE)
					temp <- temp + maxCom
					partition[V(components[[c]])$id] <- temp
				}
				comstruct <- partitionToComstruct(partition)
				result[[2]] <- comstruct
			}
						
			return(result)
		}
	)
)
