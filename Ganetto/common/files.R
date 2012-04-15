###############################################################################
## This file contains various file-related functions,
## used by other functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

## Returns the extension of the specified filename, including the dot.
## e.g. "myfile.ext" -> ".ext".
##
## @param fileName
##		The file name to be processed.
## @returns
##		A string corresponding to the extension of the file name.
getFileExtension <- function(fileName)
{	result <- NULL
	
	tmp <- strsplit(fileName,"\\.")
	temp <- tmp[[1]]
	if(length(temp)>1)
		result <- paste(".",temp[length(temp)],sep="")
	
	return(result)
}

## Returns the name of the specified file,
## without the extension.
## E.g. "myfile.ext" -> "myfile"
## @param fileName
##		The file name to be processed.
## @returns
##		A string corresponding to the name without the extension.
getFileBasename <- function(filename)
{	result <- filename
	tmp <- strsplit(filename,"\\.")
	temp <- tmp[[1]]
	if(length(temp)>1)
	{	result <- temp[1]
		if(length(temp)>2)
		{	for(i in 2:(length(temp)-1))
				result <- paste(result,".",temp[i],sep="")
		}
	}
	return(result)
}

## Receives a folder full path and checks if its
## parent exists. If it does not, then it is created,
## possibly with all its ancestors.
##
## @param fullPath
##		The folder path to be processed.
checkParentFolder <- function(fullPath)
{	parentPath <- dirname(fullPath)
	if(!file.exists(parentPath))
		dir.create(parentPath, showWarnings=TRUE, recursive=TRUE)
}

## Receives a folder full path and checks if it exists
## If it does not, then it is created,
## possibly with all its ancestors.
##
## @param fullPath
##		The folder path to be processed.
checkFolder <- function(fullPath)
{	if(!file.exists(fullPath))
		dir.create(fullPath, showWarnings=TRUE, recursive=TRUE)
}
