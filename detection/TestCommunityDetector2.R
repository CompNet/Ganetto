###############################################################################
## Full test of the internal community detection algorithms, i.e. those
## implemented as igraph functions.
##
## @author Vincent Labatut
## @version 3
###############################################################################

### algo parameters
# edge-betweenness
	ebParams <- ParameterTree$new()
	param <- ParameterNode$new(
		children=list(),
		internalName="considerDirections",
		fileName="directed",
		plotText="Directed",
		value=TRUE,
		parent=ebParams,
		use="VAR_PRIMARY"
	)
	ebParams$addChild(param)
# fast greedy
	fgParams <- ParameterTree$new()
	param <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=TRUE,
		parent=fgParams,
		use="VAR_PRIMARY"
	)
	fgParams$addChild(param)
# label propagation
	lpParams <- ParameterTree$new()
	param <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=TRUE,
		parent=lpParams,
		use="VAR_PRIMARY"
	)
	lpParams$addChild(param)
# leading eigenvector
	leParams <- ParameterTree$new()
	param <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=TRUE,
		parent=leParams,
		use="VAR_PRIMARY"
	)
	leParams$addChild(param)
# spin glass
	sgParams <- ParameterTree$new()
	param <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=TRUE,
		parent=sgParams,
		use="VAR_PRIMARY"
	)
	sgParams$addChild(param)
# walk trap
	wtParams <- ParameterTree$new()
	param1 <- ParameterNode$new(
		children=list(),
		internalName="steps",
		fileName="steps",
		plotText="steps",
		value=2,
		parent=wtParams,
		use="VAR_PRIMARY"
	)
	wtParams$addChild(param1)
	param2 <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=TRUE,
		parent=param1,
		use="VAR_PRIMARY"
	)
	param1$addChild(param2)
	param3 <- ParameterNode$new(
		children=list(),
		internalName="considerDirections",
		fileName="directed",
		plotText="Directed",
		value=TRUE,
		parent=param2,
		use="VAR_PRIMARY"
	)
	param2$addChild(param3)
	
### algo objects
algos <- list(
	CommunityDetectorInternalEdgebetweenness$new(parameters=ebParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		),
	CommunityDetectorInternalFastgreedy$new(parameters=fgParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		),
	CommunityDetectorInternalLabelpropagation$new(parameters=lpParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		),
	CommunityDetectorInternalLeadingeigenvector$new(parameters=leParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		),
	CommunityDetectorInternalSpinglass$new(parameters=sgParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		),
	CommunityDetectorInternalWalktrap$new(parameters=wtParams,
			networkInFormat=NetworkFormatPajek$new(),
			comstructOutFormat=ComstructFormatPajek$new()
		)
)

### launch process
# the parameter tree comes from the generative model tests
parameterTree$applyToParameterTree(
	foo=applyAlgorithmsToParameterTree, 
	algorithms=algos
)
