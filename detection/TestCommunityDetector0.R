###############################################################################
## Tests the sensitivity of community detection algorithms to weights.
##
## @author Vincent Labatut
## @version 3
###############################################################################

### considering the weights in this network should really change the detected communities
network <- graph(edges=c(0,1,1,2,2,3,3,0,3,4,4,5,5,6,6,7,7,4), directed=FALSE)
E(network)$weight <- c(1,1,1,1,10,1,1,1,1)
plot(network, layout=layout.fruchterman.reingold(network))

# algos
#result <- edge.betweenness.community(graph=network, edge.betweenness=FALSE, merges=TRUE, bridges=FALSE, labels=FALSE)
#result <- fastgreedy.community(graph=as.undirected(network,mode="collapse"), merges=TRUE, modularity=TRUE)
result <- walktrap.community(graph=network, steps=2, merges=TRUE, modularity=TRUE, labels=TRUE)
for(i in 1:nrow(result$merge))
	print(community.to.membership(graph=network, merges=result$merges, steps=i, membership=TRUE, csize=FALSE)$membership)

#result <- leading.eigenvector.community(graph=as.undirected(network,mode="collapse"))

#result <- label.propagation.community (graph=network)
#print(result)

#result <- spinglass.community(graph=connectNetwork(network))
#print(result$membership)