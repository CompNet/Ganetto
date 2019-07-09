###############################################################################
## This class represents a parameter value, i.e. a node in the parameter tree.
## It is necessarily the child of another Parameter, either a ParameterTree ot
## a ParameterNode.
##
## @author Vincent Labatut
## @version 3
###############################################################################

# ParameterNode
ParameterNode <- setRefClass("ParameterNode",
	contains = "Parameter",
	
	fields = list(
		## Name used internally to represent this parameter.
		internalName="character",
		
		# named used in filenames to represent this parameter
		fileName="character",
		
		## Text appearing in plots to represent this parameter.
		plotText="character",
		
		## Value of this parameter.
		value="ANY",
		
		## Parent of this parameter in the parameter tree.
		parent="Parameter",
		
		## Represents how this ParameterNode should be used:
		##		FIXED: the value should be taken as is.
		##		IGNORE: the rest of the subtree should be ignored.
		##		AGGREGATE: the value should be aggregated with sibling nodes of same name.
		##		VAR_PRIMARY: the step is a main variable, it can take this value.
		##		VAR_SECONDARY: same thing, but the step is a secondary variable used for additional series.
		##		VAR_TERTIARY: same thing, but the step is a tertiary variable used for additional plots.
		use="character"
	),
	
	methods = list(
		## Returns a textual representation of this ParameterNode,
		## including its subtree (i.e. children).
		##
		## @returns
		## 		A string representing this Parameter.
		toString = function()
		{	depth <- getDepth()
			result <- paste(rep('.',depth*2),collapse="",sep="")
			result <- paste(result,"internalName=",internalName,", ",sep="")
			result <- paste(result,"fileName=",fileName,", ",sep="")
			result <- paste(result,"plotText=",plotText,", ",sep="")
			if(class(value)!="function" && class(value)!="refMethodDef")
				result <- paste(result,"value=",value,"\n",sep="")
			else
				result <- paste(result,"value=function\n",sep="")
			for(child in children)
				result <- paste(result,child$toString(),sep="")
			return(result)
		},
		
		## Returns the next sibling of this node in the parameter tree
		## or NULL if there is no such sibling.
		##
		## @returns
		## 		The ParameterNode following this Parameter in terms of siblings.
		getNextSibling = function()
		{	result <- parent$getNextChild(.self)
			return(result)
		},
		
		## Returns the full path associated to this ParameterNode.
		## 
		## @returns
		##		A string corresponding to a full path.
		getFullPath = function()
		{	result <- paste(parent$getFullPath(),"/",fileName,"=",value,sep="")
			return(result)
		},

		## Returns the basic path associated to this ParameterNode,
		## i.e. the path associated to the tree root.
		## 
		## @returns
		##		The path associated to the root of the parameter tree.
		getBasePath = function()
		{	return(parent$getBasePath())
		},
		
		## Returns a named list of all the parameters/values defined in
		## the branch ending with this ParameterNode.
		##
		## @returns
		##		Named list of values.
		getParameterValues = function()
		{	result <- parent$getParameterValues()
			result[[internalName]] <- value
			return(result)
		},
		
		## Returns the next node when performing a deep-first
		## browsing of the whole tree, or NULL if there is no
		## node left to browse.
		##
		## @returns
		##		The next ParameterNode leaf in this tree.
		getNextLeaf = function()
		{	#browser()			
			result <- NULL
			
			# try to retrieve the next sibling
			tmp <- .self
			sib <- NULL
			repeat
			{	sib <- tmp$getNextSibling()
				if(is.null(sib) && !tmp$isRoot())
					tmp <- tmp$parent
				else
					break
			}
			
			# if there was a sibling left
			if(!is.null(sib))
			{	# find the next leaf
				#print(sib)				
				result <- sib$getFirstLeaf()
			}
			
			return(result)
		},
		
		## Tests whether this ParameterNode is the root.
		## 
		## @return
		##		Always FALSE for this class.
		isRoot = function()
		{	return(FALSE)
		},
		
		## Returns the node depth.
		##
		## @returns
		##		An integer corresponding to the depth of this ParameterNode in the parameter tree.
		getDepth = function()
		{	result <- parent$getDepth() + 1
			return(result)
		}
	)
)
