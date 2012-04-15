###############################################################################
## Tests the parameter-related functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

param0 <- ParameterConstant$new(
		children=list(),
		internalName="zzz",
		plotText="zzz",
		value=55
)

parameterTree <- ParameterTree$new(
	folderPath="home",
	constantParameters=list(param0),
	children=list()
)

for(n in c("first","second","third"))
{	# create first parameter
	param1 <- ParameterNode$new(
			children=list(),
			internalName="aaa",
			fileName="aaa",
			plotText="aaa",
			value=n,
			parent=parameterTree,
			use="VAR_PRIMARY"
	)
	# add to father
	parameterTree$addChild(param1)
	
	# create second parameters
	for(p in c(1,2,3,4))
	{	# create second parameter
		param2 <- ParameterNode$new(
			children=list(),
			internalName="bbb",
			fileName="bbb",
			plotText="bbb",
			value=p,
			parent=param1,
			use="VAR_PRIMARY"
		)
		# add to father
		param1$addChild(param2)
		
		# init third param values
		if(n=="first")
			val3 <- c(0.1,0.2)
		else if (n=="second")
			val3 <- c(0.2,0.3)
		else if (n=="third")
			val3 <- c(0.2,0.4)
		
		# create third parameters
		for(inprop in val3)
		{	# init parameter
			param3 <- ParameterNode$new(
				children=list(),
				internalName="ccc",
				fileName="ccc",
				plotText="ccc",
				value=inprop,
				parent=param2,
				use="VAR_PRIMARY"
			)
			# add to father
			param2$addChild(param3)
		}
	}
}

f <- parameterTree$getFirstLeaf()
leaves <- parameterTree$getLeafList()
paths <- parameterTree$getFullPathList()
values <- leaves[[1]]$getParameterValues()
parameterTree2 <- folderToParameterTree(dataRoot)
parameterTree3 <- listToParameterTree(folderPath=dataRoot,
		values=list(A=c(1,2,3),B=c("first","second"),C=c(0.1,0.2,0.3)),
		fileNames=list(A="a",B="b",C="c"),
		textNames=list(A="aaa",B="bbb",C="ccc"))
