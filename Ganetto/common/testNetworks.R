###############################################################################
## Tests the general network functions.
##
## @author Vincent Labatut
## @version 3
###############################################################################


#g <- graph.empty(n=10, directed=TRUE)
g <- graph(edges=c(1,2,1,3,2,4,3,4,3,5,4,5,
				6,7,6,9,7,8,7,10,8,9,8,10,9,10,
				11,12,11,13,12,13), directed=TRUE)
#plot(g,layout=layout.fruchterman.reingold(g))

g2 <- connectComponents(network=g, interProp=1/3)
plot(g2,layout=layout.fruchterman.reingold(g2))
