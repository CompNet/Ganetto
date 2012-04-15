###############################################################################
## This file contains general functions related to community structure handling.
##
## @author Vincent Labatut
## @version 3
###############################################################################

## Builds a new Comstruct object using the specified partition.
## The partition takes the form of an integer vector whose values
## correspond to community ids. The first value represents the
## community of the first node in the network, and so on.
## 
## @param partition
##		The original partition under the form of an integer vector.
## @return
##		A Comstruct object representing the original partition.
partitionToComstruct <- function(partition)
{	result <- Comstruct$new()

	# negative values are considered as nodes without any community
	partition[partition<0] <- NA
	
	# normalize community numbering
	minCom <- min(partition, na.rm=TRUE)
	if(minCom!=1)
		partition <- partition + (1-minCom)
		
	# create community list
	communities <- lapply(as.list(1:max(partition,na.rm=TRUE)), 
			function(com) which(partition==com) - 1)
	
	# update object
	result$communities <- communities
	
	return(result)
}

## Builds a list of Comstruct object from a dendrogram, each object representing
## a different hierarchical level of community structure.
##
## The input merge matrix is of the form of those produced by igraph,
## i.e. a n x 2 matrix containing the ids of merged communities.
## Communities are numbered from zero, and ids smaller than the number
## of nodes in the network correspond to singleton communities (a community
## containing only one node). Each row in the matrix indicates a merge between
## two communities, resulting in a larger one whose id is the largest existing
## id plus one.
## 
## As requested in Ganetto, the communities in the outputed structure
## are numbered from 1. Moreover, the numbering of the different hierarchical 
## levels are independent.
##
## @param network
##		The network whose community structure is represented by the merge matrix.
## @param dendrogram
##		The original igraph merge matrix.
## @param evMembership
##		Only for the EigenVector algorithm, which requires a slightly different
##		process: the membership vector obtained at the end of the community 
##		detection process. 
## @return
##		A list whose each element represent a hierarchical level of the
##		dendrogram, i.e. a community.
dendrogramToComstructList <- function(network, dendrogram, evMembership)
{	# init
	result <- list()
	size <- dim(dendrogram)[1]
	warn <- FALSE
	
	# special case: no merge at all 
	if(size==0)
	{	warning("Static$dendrogramToComstructList: the received dendrogram is empty.\n")
		membership <- rep(1,vcount(network))
#		if(divisive)
#			membership <- rep(1,vcount(network))
#		else
#			membership <- 1:vcount(network)
		comstruct <- partitionToComstruct(membership)
		result[[1]] <- comstruct
	}
	
	# normal case
	else
	{	for(i in 0:size)
		{	# special case: EigenVector algorithm uses a different function
			if(!missing(evMembership))
			{	membership <- community.le.to.membership(merges=dendrogram,
					steps=i, membership=evMembership
				)$membership
			}
			
			# special case: level 0 (no merge yet)
			else if(i==0)
			{	membership <- community.to.membership(graph=network,
						merges=dendrogram, steps=i, membership=TRUE, csize=FALSE
					)$membership
			}
				
			# normal case: some other level requiring to merge
			else
			{	if(!(dendrogram[i,1]<1 && dendrogram[i,2]<1))
					membership <- community.to.membership(graph=network,
							merges=dendrogram, steps=i, membership=TRUE, csize=FALSE
						)$membership
				else
				{	warn <- TRUE
					membership <- c()
				}
			}
			
			# build comstruct
			if(length(membership)>0)
			{	comstruct <- partitionToComstruct(membership)
				result <- c(result,comstruct)
			}
		}
	}
	
	if(warn)
		warning("Static$dendrogramToComstructList: an algorithm (certainly Walktrap) generated a dendrogram with a (0 0) line.")
	
	return(result)
}
