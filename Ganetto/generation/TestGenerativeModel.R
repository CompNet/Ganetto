###############################################################################
## Tests the generative models functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################


gen <- GenerativeModelComponentConnect$new(
	networkFormat=NetworkFormatPajek$new(),
	comstructFormat=ComstructFormatPajek$new()
)

#############################################
# Simple tests
#############################################
## erdos-renyi-based communties, uniform community sizes
#result <- gen$generateData(n=100, comDistribFoo=gen$drawUniformComstruct,
#	netGenFoo=erdos.renyi.game, interProp=0.1,
#	comp.p=0.25, comp.type="gnp", comp.directed=TRUE, comp.loops=FALSE,
#	distrib.k=10)
#print(result)
#plot(result$network,
#	layout=layout.fruchterman.reingold(result$network),
#	vertex.color=result$comstruct$getCommunityList()
#)

## barabasi-albert-based communties, power law distributed community sizes)
#foo <- function(...) as.integer(rpower(...))
#result <- gen$generateData(n=100, comDistribFoo=foo,
#		netGenFoo=barabasi.game, interProp=0.1,
#		comp.m=6, comp.directed=FALSE,
#		distrib.expnt=2, distrib.xmin=2, distrib.xmax=100)
#print(result)
#plot(result$network,
#		layout=layout.fruchterman.reingold(result$network),
#		vertex.color=result$comstruct$getCommunityList()
#)




#############################################
# Parameter-based generation
#############################################
parameterTree <- ParameterTree$new(
	folderPath=dataRoot,
	constantParameters=list(),
	children=list()
)

parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="noSelfLink",
		plotText="No self-link",
		value=TRUE
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="noMultipleLink",
		plotText="No multiple link",
		value=TRUE
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="comDistribFoo",
		plotText="comDistribFoo",
		value=gen$drawUniformComstruct
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="netGenFoo",
		plotText="netGenFoo",
		value=erdos.renyi.game
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="comp.type",
		plotText="comp.type",
		value="gnp"
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="comp.directed",
		plotText="comp.directed",
		value=TRUE
	)
)
parameterTree$addConstantParameter(
	ParameterConstant$new(
		children=list(),
		internalName="comp.loops",
		plotText="comp.loops",
		value=FALSE
	)
)

for(n in c(100,1000))
{	# create first parameter
	param1 <- ParameterNode$new(
		children=list(),
		internalName="n",
		fileName="n",
		plotText="n",
		value=n,
		parent=parameterTree,
		use="VAR_PRIMARY"
	)
	# add to father
	parameterTree$addChild(param1)
	
	# create second parameters
	for(p in c(0.1, 0.15, 0.2))
	{	# create second parameter
		param2 <- ParameterNode$new(
			children=list(),
			internalName="comp.p",
			fileName="ERp",
			plotText="Erdos-Renyi p",
			value=p,
			parent=param1,
			use="VAR_PRIMARY"
		)
		# add to father
		param1$addChild(param2)
		
		# create third parameters
		for(inprop in c(0.1, 0.2))
		{	# init parameter
			param3 <- ParameterNode$new(
				children=list(),
				internalName="interProp",
				fileName="interprop",
				plotText="Inter-com. links",
				value=inprop,
				parent=param2,
				use="VAR_PRIMARY"
			)
			# add to father
			param2$addChild(param3)
			
			for(k in c(10, 25))
			{	# init parameter
				param4 <- ParameterNode$new(
					children=list(),
					internalName="distrib.k",
					fileName="k",
					plotText="Com. nbr",
					value=k,
					parent=param3,
					use="VAR_PRIMARY"
				)
				# add to father
				param3$addChild(param4)
			}
		}
	}
}


#parameterTree$applyToParameterTree(gen$generate, mute=TRUE)
