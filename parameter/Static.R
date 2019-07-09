###############################################################################
## This file contains several functions considered as static relatively to the
## ParameterXxxx classes.
##
## Several constructors allow to build parameter trees using various data.
##
## @author Vincent Labatut
## @version 3
###############################################################################

## Builds a ParameterTree object by analyzing the specified folder
## and its content. Parameters are automatically identified by looking
## for the symbol "=" in folder names.
##
## @param folderPath
##		The folder containing the folders to be analyzed.
## @returns
##		A ParameterTree object whose structure mimic the folder's.
folderToParameterTree <- function(folderPath)
{	# init the ParameterTree result
	result <- ParameterTree$new(
			folderPath=folderPath,
			children=list()
	)
	
	# init its children
	folderToParameterAux(parent=result)
	
	return(result)
}

## Helper function used by folderToParameterTree
## to parse secondary folders.
folderToParameterAux <- function(parent)
{	#browser()
	# get the files contained in the specified folder
	folderPath <- parent$getFullPath()
	content <- list.files(path=folderPath, all.files=TRUE,
			full.names=FALSE, recursive=FALSE,
			ignore.case=FALSE)
	content <- content[content!="."]
	content <- content[content!=".."]
	
	# process each one and possibly create a parameter
	children <- sapply(content, function(fileName)
		{	result <- NULL
			# build the full file path
			filePath <- paste(folderPath,"/",fileName,sep="")
			# check if it's a folder
			if(file.info(filePath)$isdir)
			{	# look for a "=" inside the folder name
				strings <- strsplit(x=fileName, split="=", fixed=TRUE)[[1]]
				if(length(strings)>1)
				{	# get the parameter properties
					name <- strings[1]
					suppressWarnings(value <- as.numeric(strings[2]))
					if(is.na(value))
						value <- strings[2]
					
					# create the ParameterNode
					result <- ParameterNode$new(
							children=list(),
							internalName=name,
							fileName=name,
							plotText=name,
							value=value,
							parent=parent,
							use="VAR_PRIMARY"
					)
					
					# process its children
					folderToParameterAux(parent=result)
				}
			}
			return(result)
		})
	
	# add children to the specified parameter
	children <- children[!is.null(children)]
	parent$addChildren(children)
}

## Builds a ParameterTree object from a list of parameters, by
## taking them in the specified order and creating a regular structure.
##
## @param folderPath
##		The base folder for the ParameterTree to be created.
## @param values
##		The parameter values.
## @param fileNames
##		The texts used to describe the parameters in the file system. 
## @param textNames
##		The texts used to describe the parameters in the plots.
## @return
##		The corresponding ParameterTree.
listToParameterTree <- function(folderPath, values, fileNames, textNames)
{	# init parameters
	names <- names(values)
	if(missing(fileNames))
	{	fileNames <- list()	
		for(n in names)
			fileNames[[n]] <- n
	}
	if(missing(textNames))
	{	textNames <- list()	
		for(n in names)
			textNames[[n]] <- n
	}
	
	# init the result object
	result <- ParameterTree$new(
				folderPath=folderPath,
				children=list()
		)

	listToParameterAux(parent=result, values=values, fileNames=fileNames, textNames=textNames)
		
	return(result)
}

## Helper function used by listToParameterTree.
listToParameterAux <- function(parent, values, fileNames, textNames)
{	if(length(values)>0)
	{	# retrieve the next parameter and its properties
		param <- values[[1]]
		name <- names(values[1])
		fileName <- fileNames[[name]]
		textName <- textNames[[name]]
		
		# update the list of remaining parameters
		#browser()
		if(length(values)>1)
			values <- values[2:length(values)]
		else
			values <- list()
		
		# process each value for the first parameter
		children <- sapply(param, function(value)
			{	# create the ParameterNode
				result <- ParameterNode$new(
						children=list(),
						internalName=name,
						fileName=fileName,
						plotText=textName,
						value=value,
						parent=parent,
						use="VAR_PRIMARY"
					)
			
				# process its children
				listToParameterAux(parent=result,values=values,fileNames=fileNames,textNames=textNames)
				
				return(result)
			})
		
		# add children to the specified parameter
		parent$addChildren(children)
	}
}
