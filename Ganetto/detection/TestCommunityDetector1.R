###############################################################################
## Tests directly igraph community detection algorithms.
##
## @author Vincent Labatut
## @version 3
###############################################################################

### basic algorithm tests
#network <- graph(edges=c(1,2,1,3,2,4,3,4,3,5,4,5,
#				6,7,6,9,7,8,7,10,8,9,8,10,9,10,
#				11,12,11,13,12,13), directed=TRUE)
#plot(network, layout=layout.fruchterman.reingold(network))
#components <- decompose.graph(graph=network,mode="weak")
#E(network)$weight <- round(runif(ecount(network),1,5))
# algos
#edge.betweenness.community(graph=network, edge.betweenness=FALSE, merges=TRUE, bridges=FALSE, labels=FALSE)
#fastgreedy.community(graph=as.undirected(network,mode="collapse"), merges=TRUE, modularity=TRUE)
#label.propagation.community (graph=network)
#leading.eigenvector.community(graph=as.undirected(network,mode="collapse"))
#spinglass.community(graph=connectNetwork(network))
#walktrap.community(graph=network, steps=2, merges=TRUE, modularity=TRUE, labels=TRUE)

### object test
algos <- list(
		CommunityDetectorInternalEdgebetweenness$new(acceptsWeights=TRUE,acceptsDirections=TRUE),
		CommunityDetectorInternalFastgreedy$new(acceptsWeights=TRUE,acceptsDirections=TRUE),
		CommunityDetectorInternalLabelpropagation$new(acceptsWeights=TRUE,acceptsDirections=TRUE),
		CommunityDetectorInternalLeadingeigenvector$new(acceptsWeights=TRUE,acceptsDirections=TRUE),
		CommunityDetectorInternalSpinglass$new(acceptsWeights=TRUE,acceptsDirections=TRUE),
		CommunityDetectorInternalWalktrap$new(acceptsWeights=TRUE,acceptsDirections=TRUE)
	)
for(algo in algos)
{	cat("Applying algo",algo$plotText,"\n")
	for(directions in c(FALSE,TRUE))
	{	for(weights in c(FALSE,TRUE))
		{	cat("..directions=",directions," weights=",weights,"\n",sep="")
			result <- algo$detectCommunities(network=network, 
				considerDirections=directions, considerWeights=weights)
			print(result)
		}
	}
}
