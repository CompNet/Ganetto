###############################################################################
## This abstract class in is in charge of loading/recording community structures.
## Each different format must take the form of a new class iheriting this one.
##
## @author Vincent Labatut
## @version 3
###############################################################################

ComstructFormat <- setRefClass("ComstructFormat",
	methods = list(
		## Reads a community structure from a file.
		##
		## @param fullPath
		##		The path of the file to be read.
		## @returns
		##		A Comstruct object corresponding to the read data.
		readComstruct = function(fullPath)
		{	return(NA)
		},
		
		## Writes a community structure in a file.
		##
		## @param comstruct
		##		The Comstruct object to be written.
		## @param fullPath
		##		The path of the file to be written.
		writeComstruct = function(comstruct, fullPath)
		{	return(NA)
		},
		
		## Returns the file extension associated to 
		## this specific format (including the dot).
		##
		## @returns
		##		A string corresponding to the file extentions.
		getFileExt = function()
		{	return(NULL)
		},
		
		## Complete the specified file path, in case it points at a folder,
		## or the file extension is missing/inappropriate. Both conditions
		## can be handled independtly.
		##
		## @param fullPath
		##		The path to be completed.
		## @param folderCheck
		##		If TRUE, the existence of the folder containing the file will
		##		be tested, and the folder will be created if needed.
		## @param extCheck
		##		If TRUE, the end of the path will be checked, and will be
		## 		appended with an appropriate extension if it is not already present.
		completeFullPath = function(fullPath, folderCheck=TRUE, extCheck=TRUE)
		{	result <- fullPath
			
			# if the path points at a folder: add the file name
			if(folderCheck)
			{	if(file.exists(result) && file.info(result)$isdir)
					result <- paste(result,"/comstruct",sep="")
			}
			
			# if the file extension is not appropriate, add one
			if(extCheck)
			{	observedExt <- getFileExtension(result)
				targetExt <- getFileExt()
				if(is.null(observedExt) || observedExt!=targetExt)
					result <- paste(result,targetExt,sep="")
			}
			
			return(result)
		}
	)
)

# load related files
source("Ganetto/comstructformat/ComstructFormatNodelist.R")
source("Ganetto/comstructformat/ComstructFormatPajek.R")
source("Ganetto/comstructformat/ComstructFormatRosvallBergstromMap.R")
source("Ganetto/comstructformat/ComstructFormatRosvallBergstromTree.R")
