###############################################################################
## Tests the community structure functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

# init all types of community structures
simplePartition <- Comstruct$new(
		communities=list(c(0,1,2,3),c(4,5,6),c(7,8)),
		memberships=list()
)
crispCover <- Comstruct$new(
		communities=list(c(0,1,2,3),c(2,4,5,6),c(2,7,8)),
		memberships=list()
)
isolatesCover <- Comstruct$new(
		communities=list(c(0,1,2),c(2,4,5,6),c(2,8)),
		memberships=list()
)
fuzzyCover <- Comstruct$new(
		communities=list(c(0,1,2,3),c(2,4,5,6),c(2,7,8)),
		memberships=list(c(0.8,0.9,0.2,0.6),c(0.1,0.6,0.8,0.7),c(0.6,0.5,0.7))
)
allPartitions <- list("simplePartition"=simplePartition,
		"crispCover"=crispCover,
		"isolatesCover"=isolatesCover,
		"fuzzyCover"=fuzzyCover
)


# get various conversions
for(p in 1:length(allPartitions))
{	cat("###",names(allPartitions)[p],"###\n")
	partition <- allPartitions[[p]]
	print(partition)
	print(partition$getCommunityList())
	cat("\n")
}

# insertion of a new node
for(p in 1:length(allPartitions))
{	cat("###",names(allPartitions)[p],"###\n")
	partition <- allPartitions[[p]]
	print(partition)
	partition$insertNode(nodeId=5, coms=c(2,3), mbr=c(0.8,0.7))
	print(partition)
	cat("\n")
}
