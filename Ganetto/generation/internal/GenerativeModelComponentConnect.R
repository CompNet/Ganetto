###############################################################################
## Simple generative model, mainly used for testing purposes.
##
## It first draw a community size distributions. Then each community is generated
## as a separate network, containing the appropriate number of nodes. The networks
## are merged to obtain a single network object, containing multiple disconnected
## components (the communities to be). The final steps consists in connecting these
## communities, in order to get a community-structured network with a single (weak)
## component.
##
## The way the community size distribution is drawn is very flexible, since it relies on the
## use of GenerativeModel$drawDistribution. This means it is performed by a specific function
## (parameter comDistribFoo), which receives all the parameters starting with "distrib.".
##
## The way the components are generated is also very flexible, it also relies on
## an external function (parameter netGenFoo). This function receives all parameters
## starting with "comp.".
## 
## The community id is stored in the "community" nodal attribute in the resulting network.
##
## @author Vincent Labatut
## @version 3
###############################################################################
GenerativeModelComponentConnect <- setRefClass("GenerativeModelComponentConnect",
	contains = "GenerativeModel",
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	callSuper(...)
			internalName <<- "COMPONENT_CONNECT"
			fileName <<- "componentconnect"
			plotText <<- "ComponentConnect"
#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## This method implements the generative procedure.
		## It takes appropriate parameters and returns a list containing
		## a network (igraph object) and possibly a community structure
		## (Comstruct object).
		##
		## @param n
		##		Total number of nodes in the generated network.
		## @param comDistribFoo
		##		Function able to generate the community size distribution.
		##		It must take a parameter n corresponding to the network size.
		## @param netGenFoo
		##		Function able to generate a network. It must take a 
		##		parameter n as the size of the network.
		## @param interProp
		##		Proportion of inter-community links in the generated network.
		## @param connected
		##		Force the resulting network to be fully (weakly) connected.
		## @param noSelfLink
		##		Remove all links between a node and itself.
		## @param noMultipleLink
		##		Remove all extra links between two nodes (i.e. no more than one).
		## @param distrib.*
		##		All parameters starting by distrib. have their name trimmed and
		##		are transmitted to the comDitribFoo function
		## @param comp.*
		##		All parameters starting by comp. have their name trimmed and
		##		are transmitted to the netGenFoo function
		generateData = function(n, comDistribFoo, netGenFoo, interProp, 
				connected=TRUE, noSelfLink=TRUE, noMultipleLink=TRUE, ...)
		{	# init
			result <- list()
			
			# deal with community size distribution
			comDistrib <- drawDistribution(n, comDistribFoo, ...)
			
			# get possible additionnal parameters
			args <- list(...)
			args <- extractPrefixedValues("comp.", args)
			
			# generate separate components
			components <- list()
			comNbr <- rep(NA,n)
			for(i in 1:length(comDistrib))
			{	components[[i]] <- do.call(what=netGenFoo, args=c(n=comDistrib[i],args))
				#components[[i]] <- erdos.renyi.game(n=comDistrib[i],p=0.25,type="gnp",directed=directed,loops=FALSE)
			}
			
			# create overall graph
			membership <- c()
			network <- graph.empty(n=0,directed=is.directed(components[[1]]))
			for(i in 1:length(comDistrib))
			{	network <- graph.disjoint.union(network,components[[i]])
				membership <- c(membership,rep(i,vcount(components[[i]])))
			}
			V(network)$id <- as.vector(V(network))
			suppressWarnings(network <- connectComponents(network, interProp))
			# remove possible multiple links
			network <- simplify(network)
			# add community as a node parameter
			V(network)$community <- membership
			
			# possibly correct the network
			if(connected)
				network <- connectNetwork(network)
			if(noSelfLink || noMultipleLink)
				network <- simplify(graph=network, 
					remove.multiple=noMultipleLink,
					remove.loops=noSelfLink)
		
			result$network <- network
			result$comstruct <- partitionToComstruct(membership)
			return(result)
		}
	)
)
