###############################################################################
## Tests the community structure formats functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

filePath <- paste(dataRoot,"/community",sep="")

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

# define all formats
cfNodelist <- ComstructFormatNodelist$new()
cfPajek <- ComstructFormatPajek$new()
formats <- list(cfNodelist,cfPajek)

# record the different community structures
cat("\nrecording community structures\n")
for(p in 1:length(allPartitions))
{	name <- names(allPartitions)[p]
	cat("###",name,"###\n")
	partition <- allPartitions[[p]]
	
	for(f in formats)
	{	fullPath <- paste(filePath,".type=",name,f$getFileExt(),sep="")
		print(fullPath)
		f$writeComstruct(comstruct=partition, fullPath)
	}
	
	cat("\n")
}

# load and display the community structures
cat("\nloading community structures anc comparing them to references\n")
for(p in 1:length(allPartitions))
{	name <- names(allPartitions)[p]
	cat("###",name,"###\n")
	partition <- allPartitions[[p]]
	print(partition)
	
	for(f in formats)
	{	fullPath <- paste(filePath,".type=",name,f$getFileExt(),sep="")
		print(fullPath)
		comstruct <- f$readComstruct(fullPath)
		print(comstruct)
	}
}
