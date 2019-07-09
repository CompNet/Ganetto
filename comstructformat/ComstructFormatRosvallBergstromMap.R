###############################################################################
## This class load/records community structures under the form of a map file,
## such as those defined by Martin Rosvall and Carl T. Bergstrom for their
## algorithms (InfoMod, InfoMap, InfoHierMap, ConfInfoMap).
##
## All lines starting with # are comments and are ignored.
## Different sections are then identified with the character *.
## Among them, we use only the "Nodes" section, which contains the list
## of nodes and their community, very much like in the .tree format from
## the same authors. The main difference is the places of the nodes name and
## PageRank value are inverted:
## 		x:y "id" 0.123456
## where x is the id of the highest level community, y the rank of the node
## in this community, and so on. The following string is the id of the considered
## node in the original network. The last, real value is an algorithm-specific score 
## which we ignore on loading, whereas on recording we use dummy values. 
##
## Therefore, this format allows only to represent a set of mutually 
## exclusive communities, and possibly unclassified nodes.
## This class is meant to load such format, not really to record it (it lacks
## data in order to do so in a proper way).
##
## @author Vincent Labatut
## @version 3
###############################################################################

ComstructFormatRosvallBergstromMap <- setRefClass("ComstructFormatRosvallBergstromMap",
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
			communities <- list()
			com <- 1
			miniNode <- NA
			maxiNode <- NA
			connection <- file(fullPath,"r")
			nodeMode <- FALSE
			
			# load paquets of lines
			while(length(input <- readLines(con=connection,n=bufferSize))>0)
			{	# process each line separately
				for(i in 1:length(input))
				{	line <- input[[i]]
					
					# we ignore comments: line starting by '#'
					if(substr(line,1,1) != "#")
					{	
						# if the line starts with a *, we check the section
						if(substr(line,1,1) == "*")
						{	nodeMode <- substr(line,3,6)=="odes"
							#cat(">>>Mode change:",nodeMode,"\n",sep="")
						}
						
						# process the line only if it's in the Nodes section
						else if(nodeMode)
						{	# split the line using spaces
							temp <- strsplit(line," ")[[1]]
							
							# get the node id
							tempStr <- substr(temp[2],2,nchar(temp[2])-1)
							nodeId <- as.integer(tempStr)
							
							# upate extreme node indices
							miniNode <- min(miniNode, nodeId, na.rm=TRUE)
							maxiNode <- max(maxiNode, nodeId, na.rm=TRUE)
							
							# split the community data
							temp <- strsplit(temp[1],":")[[1]]
							
							# update community list
							com <- temp[1]
							if(is.null(communities[[com]]))
								communities[[com]] <- nodeId
							else
								communities[[com]] <- c(communities[[com]],nodeId)
						}
					}
				}
			}
			close(connection)
			
			# build the result: a comstruct object
			result <- Comstruct$new(communities=communities, memberships=list())
			
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
		{	return(".map")
		}
	)
)
