###############################################################################
## This class load/records community structures under the form of a file,
## whose each line represents a community. Each community is defined as a list
## of node ids.
##
## Therefore, this format allows to represent mutually exclusive communities,
## overlapping communities, and nodes without any community (unlike the pajek 
## community structure format).
##
## @author Vincent Labatut
## @version 3
###############################################################################

ComstructFormatNodelist <- setRefClass("ComstructFormatNodelist",
	contains = "ComstructFormat",
	
	methods = list(
		## Reads a community structure from a file.
		##
		## @param fullPath
		##		The path of the file to be read.
		## @returns
		##		A Comstruct object corresponding to the read data.
		readComstruct = function(fullPath)
		{	# init
			bufferSize <- 1000
			communities <- list()
			com <- 1
			miniNode <- NA
			connection <- file(fullPath,"r")
			
			# load paquets of lines
			while(length(input <- readLines(con=connection,n=bufferSize))>0)
			{	# process each line separately
				for(i in 1:length(input))
				{	line <- input[[i]]
					# we ignore comments: line starting by '#'
					if(substr(line,1,1) != "#")
					{	# split the line using spaces
						temp <- sapply(strsplit(line," ")[[1]], as.numeric)
						# upate minimal node index
						if(is.na(miniNode)) 
							miniNode <- temp[1]
						miniNode <- min(miniNode,temp)
						# update community list
						communities[[com]] <- temp
						com <- com + 1
					}
				}
			}
			close(connection)
			
			# check the numbering of the nodes: must start at 0 for igraph
#			if(miniNode==1)
#				result <- lapply(result, function(com) com-1)

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
				warning(paste("ComstructFormatNodelist$writeComstruct: The community structure has originally membership scores, which will be lost when recording using this format (",fullPath,").",sep=""))
			
			# record some metadata
			connection <- file(fullPath,"w")
			cat("# File created on ",format(Sys.time(),"%a %b %d %X %Y"), "\n",sep="",file=connection)
			cat("# by Ganetto v",GANETTO_VERSION,"\n",sep="",file=connection)
			cat("##########################################\n",sep="",file=connection)
			
			# record the node lists
			sapply(comstruct$communities, function(com)
			{	text <- paste(com, collapse=" ")				
				cat(text, "\n", sep="", file=connection)
			})
			close(connection)
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the a file extentions.
		getFileExt = function()
		{	return(".nodelist")
		}
	)
)
