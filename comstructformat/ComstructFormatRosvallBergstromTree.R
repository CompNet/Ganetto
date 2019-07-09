###############################################################################
## This class load/records community structures under the form of a tree file,
## such as those defined by Martin Rosvall and Carl T. Bergstrom for their
## algorithms (InfoMod, InfoMap, InfoHierMap).
##
## The first line is a comment (we ignore it), the rest of the lines take the form:
## 		x:y:z 0.123456 "id"
## where x is the id of the highest level community, y the id of the midle
## level community (numbered relatively to x), z is the id of the lower level
## community (in y), and so on. The real value is an algorithm-specific score 
## which we ignore on loading, whereas on recording we use dummy values. The 
## last value (string) is the id of the considered node.
##
## Therefore, this format allows only to represent a hierarchy of mutually 
## exclusive communities, and possibly unclassified nodes.
## This class is meant to load such format, not really to record it (it lacks
## data in order to do so in a proper way).
##
## @author Vincent Labatut
## @version 3
###############################################################################

ComstructFormatRosvallBergstromTree <- setRefClass("ComstructFormatRosvallBergstromTree",
	contains = "ComstructFormat",
	
	methods = list(
		## Reads a community structure from a file.
		##
		## @param fullPath
		##		The path of the file to be read.
		## @returns
		##		A list of Comstruct objects corresponding to 
		##		hierarchy of communities described in the file.
		readComstruct = function(fullPath)
		{	# init
			bufferSize <- 1000
			hierarchy <- list()
			com <- 1
			miniNode <- NA
			maxiNode <- NA
			connection <- file(fullPath,"r")
			
			# load paquets of lines
			while(length(input <- readLines(con=connection,n=bufferSize))>0)
			{	# process each line separately
				for(i in 1:length(input))
				{	line <- input[[i]]
					# we ignore comments: line starting by '#'
					if(substr(line,1,1) != "#")
					{	# split the line using spaces
						temp <- strsplit(line," ")[[1]]
						# get the node id
						tempStr <- substr(temp[3],2,nchar(temp[3])-1)
						nodeId <- as.integer(tempStr)
						# upate extreme node indices
						miniNode <- min(miniNode, nodeId, na.rm=TRUE)
						maxiNode <- max(maxiNode, nodeId, na.rm=TRUE)
						# split the community data
						temp <- strsplit(temp[1],":")[[1]]
						# update community list
						cumCom <- ""
						for(t in 1:length(temp))
						{	# get the appropriate community structure
							if(length(hierarchy)>=t)
								communities <- hierarchy[[t]]
							else
								communities <- list()
							# update it
							com <- temp[t]
							cumCom <- paste(cumCom,":",com,sep="")
							if(is.null(communities[[cumCom]]))
								communities[[cumCom]] <- nodeId
							else
								communities[[cumCom]] <- c(communities[[cumCom]],nodeId)
							hierarchy[[t]] <- communities
						}
					}
				}
			}
			close(connection)
			# build the result: a comstruct list
			result <- list()
			if(length(hierarchy)>0)
			{	# process each level
				for(c in 1:length(hierarchy))
				{	communities <- hierarchy[[c]]
					presentNodes <- do.call(what="c", args=communities)
					missingNodes <- setdiff(0:maxiNode,presentNodes)
					for(n in missingNodes)
						communities[[paste("MN",n,sep="")]] <- c(n)
					comstruct <- Comstruct$new(communities=communities, memberships=list())
					result <- c(comstruct, result)
				}
			}
			
			# check the numbering of the nodes: must start at 0 for igraph
#			if(miniNode==1)
#				result <- lapply(result, function(com) com-1)

			return(result)
		},
		
		## Writes a community structure in a file.
		## Not implemented yet (not really useful).
		##
		## @param comstruct
		##		The Comstruct object to be written, or a list 
		##	    of Comstruct objects if one wants to record a
		##		a hierarchy of community structures.
		## @param fullPath
		##		The path of the file to be written.
		writeComstruct = function(comstruct, fullPath)
		{	# TODO
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the a file extentions.
		getFileExt = function()
		{	return(".tree")
		}
	)
)
