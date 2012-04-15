###############################################################################
## This class represents a parameter used during the generation process, but
## which should not appear in the file system as a folder (like the other parameters).
##
## @author Vincent Labatut
## @version 3
###############################################################################

# ParameterConstant
ParameterConstant <- setRefClass("ParameterConstant",
	contains = "Parameter",
	
	fields = list(
		## Name used internally to represent this parameter.
		internalName="character",
		
		## Text appearing in plots to represent this parameter.
		plotText="character",
		
		## Value of this parameter.
		value="ANY"
	),
		
	methods = list(
		## Returns a textual representation of this ParameterConstant.
		##
		## @returns
		## 		A string representing this Parameter.
		toString = function()
		{	result <- "  "
			result <- paste(result,"internalName=",internalName,", ",sep="")
			result <- paste(result,"plotText=",plotText,", ",sep="")
			if(class(value)!="function" && class(value)!="refMethodDef")
				result <- paste(result,"value=",value,"\n",sep="")
			else
				result <- paste(result,"value=function\n",sep="")
			return(result)
		},
		
		## Tests whether this ParameterConstant is the root.
		## 
		## @return
		##		Always FALSE for this class.
		isRoot = function()
		{	return(FALSE)
		},
		
		## Returns the node depth.
		##
		## @returns
		##		Always 0 for this class.
		getDepth = function()
		{	return(0)
		}
	)
)
