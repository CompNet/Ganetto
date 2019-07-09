###############################################################################
## This class represents the root of a parameter tree. It contains some "invisible"
## parameters under the form of ParameterConstants, and a tree structure of 
## ParameterNodes.
##
## Its most important method is applyToParameterTree, which allows applying some
## function to all parameter combinations associated to the leaves of the parameter
## tree. In other words, it allows applying some processing to a whole collection
## of previously generated networks.
##
## @author Vincent Labatut
## @version 3
###############################################################################

# ParameterTree
ParameterTree <- setRefClass("ParameterTree",
	contains = "Parameter",
	
	fields = list(
		## Name of the main folder for the processed collection.
		folderPath="character",
		
		## List of constant parameters (same for all combinations).
		constantParameters="list"
	),
	
	methods = list(
		## Returns a textual representation of this ParameterTree.
		##
		## @returns
		## 		A string representing this Parameter.
		toString = function()
		{	result <- "[ "
			result <- paste(result,"folderPath=",folderPath,"\n",sep="")
			
			# process constant parameters
			result <- paste(result,"  constantParameters=[\n",sep="")
			for(param in constantParameters)
				result <- paste(result,"  ",param$toString(),sep="")
			result <- paste(result,"  ]\n",sep="")
			
			# process children
			result <- paste(result,"  children=[\n",sep="")
			for(child in children)
				result <- paste(result,child$toString(),sep="")
			result <- paste(result,"  ]\n",sep="")
			
			result <- paste(result,"]\n",sep="")
			return(result)
		},
		
		## Returns the next sibling of this node in the parameter tree
		## or NULL if there is no such sibling (e.g. for a ParameterTree,
		## or a ParameterNode without further sibling).
		##
		## @returns
		## 		Always NULL for this class.
		getNextSibling = function()
		{	return(NULL)
		},
		
		## Returns the full path associated to this ParameterTree.
		## 
		## @returns
		##		Always the base, folderPath for this class.
		getFullPath = function()
		{	return(folderPath)
		},
		
		## Returns the path associated to this ParameterTree.
		## 
		## @returns
		##		Always the base, folderPath for this class.
		getBasePath = function()
		{	return(folderPath)
		},
		
		## Returns the node depth.
		##
		## @returns
		##		Always 0 for this class.
		getDepth = function()
		{	return(0)
		},
		
		## Tests whether this ParameterTree is the root.
		## 
		## @return
		##		Always TRUE for this class.
		isRoot = function()
		{	return(TRUE)
		},
		
		## Returns a named list of all the parameters/values defined in
		## the constant parameters of this tree.
		##
		## @returns
		##		Named list of values.
		getParameterValues = function()
		{	result <- list()
			# init the list using the constant parameters
			for(param in constantParameters)
				result[[param$internalName]] <- param$value
			return(result)
		},
		
		## Returns the list of all leaves in this ParameterTree.
		##
		## @returns
		##		A list containin all the leaves in this ParameterTree.
		getLeafList = function()
		{	result <- list()
			leaf <- getFirstLeaf()
			while(!is.null(leaf))
			{	result <- c(result,leaf)
				#print(leaf)				
				leaf <- leaf$getNextLeaf()
			}
			return(result)
		},
		
		## Returns the vector of all paths described by the nodes
		## of this ParameterTree.
		##
		## @returns
		##		A vector of strings corresponding to full paths. 
		getFullPathList = function()
		{	leaves <- getLeafList()
			result <- sapply(leaves,function(x) x$getFullPath())
			return(result)
		},
		
		## Adds a single ParameterConstant to this ParameterTree.
		##
		## @param param
		##		The ParameterConstant to be added.
		addConstantParameter = function(param)
		{	constantParameters <<- c(constantParameters,param)
			#TODO check missing child parameter
		},
		
		## Adds several ParameterConstant objects to this ParameterTree.
		##
		## @param params
		##		The list of ParameterConstant objects to be added.
		addConstantParameter = function(params)
		{	# possibly transform the vector into a list
			if(class(params)!="list")
				params <- as.list(params)
			# add to current ConstantParameter
			lapply(params,.self$addConstantParameter)
		},
		
		## Apply the specified function to all parameter combinations
		## in the specified ParameterTree.
		##
		## @param foo
		##		The function to be applied to each leaf in the tree.
		## @param ...
		##		Additional parameters, to be fetched to foo.
		applyToParameterTree = function(foo, ...)
		{	leaves <- getLeafList()
			lapply(leaves,function(leaf)
			{	# init
				fullPath <- leaf$getFullPath()
				paramValues <- leaf$getParameterValues()
				
				# TODO log iteration
				cat("applying function '",as.character(quote(foo)),"' to :\n",sep="")
				cat("..fullPath=",fullPath,"\n",sep="")
				paramValuesStr = paste(sapply(names(paramValues),function(n)
				{	x <- paramValues[[n]]
					if(class(x)=="function" || class(x)=="refMethodDef")
						paste(n,"=function",sep="")
					else
						paste(n,"=",x,sep="")
				}),
				collapse=" ")
				cat("..paramValues=[ ",paramValuesStr," ]\n",sep="")
				
				# perfom the call
				do.call(what=foo, args=list(leaf=leaf, ...))
			})
		}
	)
)
