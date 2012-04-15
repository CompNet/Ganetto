###############################################################################
## This files contains general functions related to the handling of igraph networks.
## They are meant to be used by other functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

## Determines if the specified graph is weighted, 
## i.e. if numerical values are associated to its links,
## using the label 'weight'.
##
## @param network
## 		The considered igraph network.
## @return
##		TRUE iff the network links have weights.
is.weighted <- function(network)
{	weights <- get.edge.attribute(graph=network,name="weight",index=E(network))
	result <- !is.null(weights)
	return(result)
}

## Connects all the separated network components.
## The added links are directed/weighted if the original network is.
## The proportion of links between the communities can be specified.
## 
## @param network
##		The disconnected network, soon to be connected.
## @param interProp
##		The proportion of inter-community links relatively
##		to the total number of links in the final network.
##		This value must therefore be smaller than 1.
## @return
##		A connected version of the initial network.
connectComponents <- function(network, interProp=0.5)
{	#init
	result <- network
	warn <- FALSE
	intercomLinks <- round(ecount(network)*interProp/(1-interProp))
	
	# the presence of an id attribute is absolutely necessary
	if(is.null(V(network)$id))
	{	n <- vcount(network)
		V(network)$id <- 0:(n-1)
		warning("connectComponents: no ids defined -> set to 0:",(n-1))
	}
	
	# get the components
	components <- decompose.graph(network)
	# connect the components
	for(c1 in 1:length(components))
	{	comp1 <- components[[c1]]
		# get the number of links outgoing from this community
		links <- round(ecount(comp1)*interProp/(1-interProp))
		if(c1==length(components))
			links <- intercomLinks
		remainingLinks <- links
		intercomLinks <- intercomLinks - links
		
		if(links>0)
		{	# process each other community
			indices2 <- sample((1:length(components))[-c1])
			for(c2 in indices2)
			{	comp2 <- components[[c2]]
				
				# get the number of inter-community links to be created between both communities
				temp <- round(links*vcount(comp2)/(vcount(network)-vcount(comp1)))
				linkNbr <- min(remainingLinks,temp)
				if(c2==indices2[length(indices2)])
					linkNbr <- remainingLinks
				
				if(linkNbr>0)
				{	# select the source nodes
					src <- c()
					for(n in 1:linkNbr)
					{	# get the unused nodes
						available <- (1:vcount(comp1))[!(1:vcount(comp1) %in% src)]
						if(length(available)==0)
						{	available <- 1:vcount(comp1)
							warn <- TRUE
						}
						# randomly pick a node
						idx <- available[rdm(max=length(available))]
						src <- c(src, idx)
					}
					# get network-wise ids
					src <- V(comp1)$id[src]
					
					# select the target nodes
					trg <- c()
					for(n in 1:linkNbr)
					{	# get the unused nodes
						available <- (1:vcount(comp2))[!(1:vcount(comp2) %in% trg)]
						if(length(available)==0)
						{	available <- 1:vcount(comp2)
							warn <- TRUE
						}
						# randomly pick a node
						idx <- available[rdm(max=length(available))]
						trg <- c(trg, idx)
					}
					# get network-wise ids
					trg <- V(comp2)$id[trg]
					
					# create links
					edges <- as.vector(rbind(src,trg))
					if(is.weighted(network))
					{	# if the network is weighted, we generate weights using a gaussian
						avrg <- mean(E(network)$weight)
						stdev <- sd(E(network)$weight)
						weights <- rnorm(n=length(edges)/2,mean=avrg,sd=stdev)
						result <- add.edges(graph=result,edges=edges,attr=list(weight=weights))
					}
					else
						result <- add.edges(graph=result,edges=edges)
		
					# update counter
					remainingLinks <- remainingLinks - linkNbr
				}
			}
		}
	}
	
	if(warn)
		warning("connectComponents: due to the requested number of inter-community links, it is possible the obtained network contains multiple links")
	
	return(result);
}

## Connects all the components in the specified network
## using a minimal number of links. The goal is just
## to obtain a complelety (weakly) connected network.
## 
## @param network
##		The disconnected network, soon to be connected.
## @return
##		A connected version of the initial network.
connectNetwork <- function(network)
{	# init
	result <- network
	
	# the presence of an id attribute is absolutely necessary
	if(is.null(V(result)$id))
	{	n <- vcount(result)
		V(result)$id <- 0:(n-1)
		warning("connectNetwork: no ids defined -> set to 0:",(n-1))
	}
	
	# get the components
	comp <- decompose.graph(result)
	lcomp <- length(comp)
	
	# connect the components
	while(lcomp>1)
	{	# randomly choose the components
		idx = 1:lcomp
		i1 <- rdm(max=length(idx))
		tmp <- idx[i1]
		comp1 <- comp[[tmp]]
		idx <- idx[idx!=i1]
		i2 <- rdm(max=length(idx))
		comp2 <- comp[[idx[i2]]]
		
		# in each component, randomly choose a node
		i1 <- rdm(max=vcount(comp1))	
		n1 <- V(comp1)[i1-1]$id
		i2 <- rdm(max=vcount(comp2))
		n2 <- V(comp2)[i2-1]$id;
		
		# add the link in the main graph
		result <- add.edges(result,c(n1,n2))
		
		# update variables
		comp <- decompose.graph(result)
		lcomp <- length(comp)
	}
	
	return(result)
}

## Adapts the network so it fits the request.
## If it has weights and we don't want weights, those are removed.
## It it hasn't weights and we want some, those are set to 1 for all links.
## If the network already fits the request, it is not modified.
##
## @param network
## 		The network to be modified.
## @param wantsWeights
##		Whether we want weighted links or not.
## @returns
##		The modified version of the network.
adaptNetworkWeights <- function(network, wantsWeights)
{	isWeighted <- is.weighted(network)
	if(isWeighted && !wantsWeights)
	{	network <- remove.edge.attribute(graph=network, name="weight")
		warning(paste("networks$adaptNetworkWeights: The network is originally weighted: weights dropped at your demand.",sep=""))
	}
	else if(!isWeighted && wantsWeights)
	{	network <- set.edge.attribute(graph=network, name="weight", index=E(network), value=1)
		warning(paste("networks$adaptNetworkWeights: The network is not originally weighted: weights set to 1 at your demand.",sep=""))
	}
	return(network)
}

## Adapts the network so it fits the request.
## If it has directions and we don't want directions, those are colapsed while avoiding multiple links.
## It it hasn't directions and we want some, bidirectional links are created.
## If the network already fits the request, it is not modified.
##
## @param network
## 		The network to be modified.
## @param wantsDirections
##		Whether we want directed links or not.
## @returns
##		The modified version of the network.
adaptNetworkDirections <- function(network, wantsDirections)
{	isDirected <- is.directed(network)
	if(!isDirected && wantsDirections)
	{	network <- as.directed(graph=network, mode="mutual")
		warning(paste("networks$adaptNetworkDirections: The network is not originally directed: mutual directions added at your demand.",sep=""))
	}
	else if(isDirected && !wantsDirections)
	{	network <- as.undirected(graph=network, mode="collapse")
		warning(paste("networks$adaptNetworkDirections: The network is originally directed: directions dropped at your demand.",sep=""))
	}
	return(network)
}

## Sets/creates an id attribute for the network nodes.
##
## @param network
##		The network to be processed.
## @return
##		The modified version of the network
initNodeIds <- function(network)
{	V(network)$id <- 0:(vcount(network)-1)
	return(network)
}
