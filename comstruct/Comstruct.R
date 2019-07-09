###############################################################################
## This class allows representing a community structure. It is general
## enough to allow representing mutually exclusive and overlapping communities,
## isolates (nodes without any community), and binary or real membership.
##
## @author Vincent Labatut
## @version 3
###############################################################################

Comstruct <- setRefClass("Comstruct",
	fields = list(
		## List of communities, each community being a vector of node ids
		communities="list",
		
		## Optional list of membership values: like the field communities,
		## except it contains real values in [0;1] instead of node ids.
		memberships="list"
	),
	
	methods = list(
		## Processes a string representation of this object.
		## 
		## @returns
		## 		A string representation of this object.
		toString = function()
		{	return(getMembershipMatrix())
		},
		
		## Redefines the printing fonction
		show = function()
		{	print(toString())
		},
		
		## Returns the community structure under the form of a vector.
		## each value in the vector represents the community of a node.
		## A NA means the node has no community. With this representation,
		## one node cannot belong to more than one community.
		## Some information can therefore be lost when using this representation.
		##
		## @returns
		##		A partition-based representation of the community structure.
		getCommunityList = function()
		{	#init
			result <- c()
			memb <- c()
			
			# process each community separately
			for(com in 1:length(communities))
			{	# retrieve the data from the fields
				community <- communities[[com]]
				if(length(memberships)>0)
					membership <- memberships[[com]]
				else
					membership <- NA
				
				# process each node in the community
				for(n in 1:length(community))
				{	node <- community[n]
					update <- TRUE
					
					# compare with possibly existing result
					if(length(result)>node)								# TODO node numbering
					{	exCom <- result[node+1]							# TODO node numbering
						if(!is.na(exCom))
						{	if(length(memberships)>0)
								update <- memb[node+1] < membership[n]	# TODO node numbering
							else
								update <- FALSE
							if(is.na(update))
								update <- is.na(memb[node+1])
						}
					}
					
					# update result
					if(update)		
					{	result[node+1] <- com							# TODO node numbering
						if(length(memberships)>0)
							memb[node+1] <- membership[n]				# TODO node numbering
					}
				}
			}
			
			return(result)
		},
		
		## Returns the community structure under the form of a list,
		## whose elements represent the composition of a community.
		## Each element is a vector whose values represent node ids.
		## Nodes can belong to several different communities, and
		## can belong to no community at all.
		##
		## @returns
		##		The internal list-based representation of this community structure. 
		getCompositionList = function()
		{	return(communities)
		},
		
		## Returns the membership values associated to the list returned by getCompositionList.
		## Each element is a vector of float between 0 and 1. Each value represents
		## how much the corresponding node in the composition list
		## belongs to the considered community.
		##
		## @returns
		##		A list of real membership values.
		getMembershipList = function()
		{	return(memberships)
		},
		
		## Returns the community structure under the form of
		## a rectangular matrix whose rows are nodes and columns communities.
		## Each cell in the matrix quantifies the membership of the concerned
		## node to the considered community.
		##
		## @return
		##		A matrix-based representation of this community structure.
		getMembershipMatrix = function()
		{	#init
			maxNode <- max(sapply(communities,max))
			result <- matrix(data=0,nrow=maxNode+1, ncol=length(communities))
						
			# process each community separately
			for(com in 1:length(communities))
			{	community <- communities[[com]]
				if(length(memberships)>0)
					membership <- memberships[[com]]
				else
					membership <- rep(1,length(community))
				result[community+1,com] <- membership
			}
			
			return(result)
		},
		
		## Inserts a new node in the community structure, possibly
		## renumbering the existing ones. If the new node id is greater
		## than the current size, then the missing nodes are 'created',
		## and do not belong to any community.
		## 
		## @param nodeId
		##		The position where to insert the new node,
		##		which consists in modifying the ids of the following
		##		nodes.
		## @param coms
		##		The communities where to add the new node to.
		## @param mbr
		##		The corresponding membership values. 
		insertNode = function(nodeId, coms, mbr)
		{	# possibly change the existing ids
			for(c in 1:length(communities))
			{	community <- communities[[c]]
				community[community>=nodeId] <- community[community>=nodeId] + 1
				communities[[c]] <<- community
			}
			
			# adds the new node to the specified communities
			if(!missing(coms))
			for(c in 1:length(coms))
			{	community <- communities[[coms[c]]]
				community <- c(community, nodeId)
				communities[[coms[c]]] <<- community
				if(length(memberships)>0)
				{	if(missing(mbr))
						mbr <- rep(1,length(coms))
					membership <- memberships[[coms[c]]]
					membership <- c(membership, mbr[c])
					memberships[[coms[c]]] <<- membership
				}
			}
		}
	)
)

# load related files
source("Ganetto/comstruct/Static.R")
