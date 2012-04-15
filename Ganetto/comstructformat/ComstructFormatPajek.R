###############################################################################
## This class allows saving/loading a community structure under the form of
## a text file containing a single integer vector. Each line in the file represents
## the community id associated to a node. This corresponds to the pajek "cluster"
## format.
##
## This format allows representing only partitions (no overlapping communities,
## no nodes without a community). 
##
## @author Vincent Labatut
## @version 3
###############################################################################

ComstructFormatPajek <- setRefClass("ComstructFormatPajek",
	contains = "ComstructFormat",
	
	methods = list(
		## Reads a community structure from a file.
		##
		## @param fullPath
		##		The path of the file to be read.
		## @returns
		##		A Comstruct object corresponding to the read data.
		readComstruct = function(fullPath)
		{	# read the vector, skiping thre first line (header)
			table <- read.table(file=fullPath,skip=c(1))
			vect <- as.vector(table$V1)
			
			# normalize the community numbering so that it starts from 1
			if(min(vect) == 0)
				vect <- vect + 1
			
			# set the community list
			communities <- list()
			for(n in 1:length(vect))
			{	com <- vect[n]
				if(length(communities)>=com)				
					communities[[com]] <- c(communities[[com]], n-1)
				else
					communities[[com]] <- n - 1
			}
			
			# build the result
			comstruct <- Comstruct$new(communities=communities, memberships=list())
			
			return(comstruct)
		},
				
		## Writes a community structure in a file.
		##
		## @param comstruct
		##		The Comstruct object to be written.
		## @param fullPath
		##		The path of the file to be written.
		writeComstruct = function(comstruct, fullPath)
		{	# possibly create the needed folders
			checkParentFolder(fullPath)
			
			# check compatibility between comstruct data and this format
			if(length(comstruct$memberships)>0)
				warning(paste("ComstructFormatPajek$writeComstruct: The community structure has originally membership scores, which will be lost when recording using this format (",fullPath,").",sep=""))
			
			# write the header
			vect <- comstruct$getCommunityList()
			connection <- file(fullPath,"w")
			cat("*Vertices ",length(vect),"\n",sep="",file=connection)
			
			# check nodes without community
			if(length(vect[is.na(vect)])>0)
			{	warning(paste("ComstructFormatPajek$writeComstruct: The community structure originally ignores some nodes, but those will constitute individual communities in the recorded file (",fullPath,").",sep=""))
				indices <- which(is.na(vect))
				com <- max(vect, na.rm=TRUE)
				for(i in indices)
				{	com <- com + 1
					vect[i] <- com
				}
			}
			
			# check nodes belonging to several communities
			sizes <- sapply(comstruct$communities,function(l) length(l))
			nnodes <- sum(sizes)
			if(nnodes>length(vect))
				warning(paste("ComstructFormatPajek$writeComstruct: The community structure originally allows overlapping communities, but only the first community of each node is considered in the recorded file (",fullPath,").",sep=""))
			
			# write communities
			sapply(as.list(vect), function(com) cat(com, "\n", sep="", file=connection))
			close(connection)
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the a file extentions.
		getFileExt = function()
		{	return(".clu")
		}
	)
)
