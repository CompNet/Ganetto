###############################################################################
## This abstract class in is in charge of the representation of parameters.
## Those parameters are used to represent how the generated networks are
## located in the file system.
## This class contains methods and fields common to ParameterConstant, 
## ParameterNode and ParameterTree.
##
## @author Vincent Labatut
## @version 3
###############################################################################

Parameter <- setRefClass("Parameter",
	fields = list(
		## List of child ParameterNode objects
		children="list"
	),
	
	methods = list(
		## Returns a textual representation of this Parameter.
		##
		## @returns
		## 		A string representing this Parameter.
		toString = function()
		{	return(NA)
		},
		
		## Redefines the printing fonction for all parameter classes
		## (allows a better display, plus it's necessary to avoid
		## infinite loops when parsing the parameter tree).
		show = function()
		{	cat(toString(),"\n")
		},
		
		## Returns the ParameterNode child of this Parameter following the
		## specified ParameterNode child, or NULL if there is no such child.
		## An error occurs when the specified child does not
		## bellong to this parameter.
		##
		## @param child
		##	The child whose next sibling is required, or nothing to get the very first child.
		## @returns
		##	The next sibling, or NULL if there is no next sibling.
		##
		## @error
		##	If the specified child does not belong to this parameter.
		getNextChild = function(child)
		{	result <- NULL
			# the first child is required
			if(missing(child))
			{	if(length(children)>0)
					result <- children[[1]]
			}
			
			# another child is required
			else
			{	#index <- which(children==child)
				index <- which(sapply(children,function(x) identical(x,child)))
				if(is.null(index))
					stop("The specified child does not belong to this parameter.")
				else if(length(children)>index)
					result <- children[[index+1]]
			}
			#print(result)			
			return(result)
		},
		
		## Returns the next sibling of this node in the parameter tree
		## or NULL if there is no such sibling (e.g. for a ParameterTree,
		## or a ParameterNode without further sibling).
		##
		## @returns
		## 		The ParameterNode following this Parameter in terms of siblings.
		getNextSibling = function()
		{	return(NULL)
		},
			
		## Adds a ParameterNode child to this Parameter.
		## 
		## @param child
		##		The new ParameterNode child to be added to this Parameter.
		addChild = function(child)
		{	children <<- c(children,child)
			#TODO check missing child parameter
		},
		
		## Adds a list of ParameterNode children to this Parameter.
		## 
		## @param childz
		##		The new ParameterNode children to be added to this Parameter.
		addChildren = function(childz)
		{	# possibly transform the vector into a list
			if(class(childz)!="list")
				childz <- as.list(childz)
			# add to current children
			lapply(childz,.self$addChild)
		},
		
		## Abstract method returning the full path associated to this Parameter.
		## 
		## @returns
		##		A string corresponding to a full path.
		getFullPath = function()
		{	return(NULL)
		},
		
		## Returns the path associated to this Parameter.
		## 
		## @returns
		##		The path associated to the root of the parameter tree.
		getBasePath = function()
		{	return(NULL)
		},
		
		## Tests whether this Parameter is a leaf.
		## 
		## @return
		##		TRUE iff the Parameter is a leaf in the parameter tree.
		isLeaf = function()
		{	result <- length(children)==0
			return(result)
		},
		
		## Tests whether this Parameter is the root.
		## 
		## @return
		##		TRUE iff the Parameter is the root of the parameter tree.
		isRoot = function()
		{	return(NULL)
		},
		
		## Returns the first leaf which is a descendent of this node,
		## or this node if it is itself a leaf.
		##
		## @returns
		##		A Parameter which is the first leaf connected to this Parameter.
		getFirstLeaf = function()
		{	result <- NULL
			if(isLeaf())
				result <- .self
			else
				result <- children[[1]]$getFirstLeaf()
			return(result)
		},
		
		## Returns the following leaf when performing a deep-first
		## browsing of the whole tree, or NULL if there is no
		## node left to browse.
		##
		## @returns
		##		The next Parameter leaf in this tree.
		getNextLeaf = function()
		{	return(NULL)
		},
		
		## Returns the node depth.
		##
		## @returns
		##		An integer corresponding to the depth of this Parameter in the parameter tree.
		getDepth = function()
		{	return(NULL)
		},
		
		## Returns a named list of all the parameters/values defined in
		## the branch ending with this Parameter.
		##
		## @returns
		##		Named list of values.
		getParameterValues = function()
		{	result <- NULL
		}
	)
)

# load related files
source("Ganetto/parameter/ParameterTree.R")
source("Ganetto/parameter/ParameterNode.R")
source("Ganetto/parameter/ParameterConstant.R")
source("Ganetto/parameter/Static.R")
