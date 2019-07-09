###############################################################################
## This files contains functions related to lists, vectors, etc.
## They are destined to be used by other functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################


## Receives a named list and a prefix, and extract all
## the values whose names start with the prefix.
## The result is a list containing all the selected values,
## but their names in this new list are trimmed (no more prefix).
## Example: for the input prefix="pref", lst=list(abc=132, prefabc=456, prefB=567, ref=789)
## we get the result list(abc=456, B=567).
##
## @param prefix
##		The prefix of interest.
## @param parameters
##		The named list to be processed.
## @return
##		A new list containing only the prefixed values,
##		but trimmed from their prefix.
extractPrefixedValues <- function(prefix, lst)
{	result <- list()
	
	if(length(lst)>0)
	{	# get the parameter names
		paramNames <- names(lst)
		
		# get parameters starting with the appropriate prefix
		paramIndices <- grep(pattern=prefix, x=paramNames, fixed=TRUE)
		if(length(paramIndices)>0)
		{	# init result list
			result <- lst[paramIndices]
			# remove the prefix to trim the names
			names(result) <- sub(pattern=prefix, replacement="", x=names(result), fixed=TRUE)
		}
	}
	
	return(result)
}
