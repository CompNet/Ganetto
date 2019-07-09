###############################################################################
## Full test of the external community detection algorithms, i.e. those
## not implemented as igraph functions.
##
## @author Vincent Labatut
## @version 3
###############################################################################

### algo parameters
# info mod
imodParams <- ParameterTree$new()
for(v in c(FALSE,TRUE))
{	param <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=v,
		parent=imodParams,
		use="VAR_PRIMARY"
	)
	imodParams$addChild(param)
}
# info map
imapParams <- ParameterTree$new()
for(v1 in c(FALSE,TRUE))
{	param1 <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=v1,
		parent=imapParams,
		use="VAR_PRIMARY"
	)
	imapParams$addChild(param1)
	for(v2 in c(FALSE,TRUE))
	{	param2 <- ParameterNode$new(
			children=list(),
			internalName="considerDirections",
			fileName="directed",
			plotText="Directed",
			value=v2,
			parent=param1,
			use="VAR_PRIMARY"
		)
		param1$addChild(param2)
	}
}
# conf info mqp
cimapParams <- ParameterTree$new()
for(v in c(FALSE,TRUE))
{	param <- ParameterNode$new(
			children=list(),
			internalName="considerDirections",
			fileName="directed",
			plotText="Directed",
			value=v,
			parent=cimapParams,
			use="VAR_PRIMARY"
	)
	cimapParams$addChild(param)
}
# info hier map
ihmapParams <- ParameterTree$new()
for(v1 in c(FALSE,TRUE))
{	param1 <- ParameterNode$new(
		children=list(),
		internalName="considerWeights",
		fileName="weighted",
		plotText="Weighted",
		value=FALSE,
		parent=ihmapParams,
		use="VAR_PRIMARY"
	)
	ihmapParams$addChild(param1)
	for(v2 in c(FALSE,TRUE))
	{	param2 <- ParameterNode$new(
			children=list(),
			internalName="considerDirections",
			fileName="directed",
			plotText="Directed",
			value=FALSE,
			parent=param1,
			use="VAR_PRIMARY"
		)
		param1$addChild(param2)
	}
}

### algo objects
algos <- list(
#	CommunityDetectorExternalInfomod$new(parameters=imodParams,
#			networkInFormat=NetworkFormatPajek$new(),
#			comstructOutFormat=ComstructFormatPajek$new(),
#			hideConsole=TRUE
#	),
#	CommunityDetectorExternalInfomap$new(parameters=imapParams,
#			networkInFormat=NetworkFormatPajek$new(),
#			comstructOutFormat=ComstructFormatPajek$new(),
#			hideConsole=TRUE
#	),
#	CommunityDetectorExternalConfinfomap$new(parameters=cimapParams,
#			networkInFormat=NetworkFormatPajek$new(),
#			comstructOutFormat=ComstructFormatPajek$new(),
#			hideConsole=TRUE
#	),
#	CommunityDetectorExternalInfohiermap$new(parameters=ihmapParams,
#			networkInFormat=NetworkFormatPajek$new(),
#			comstructOutFormat=ComstructFormatPajek$new(),
#			hideConsole=TRUE
#	)
)

### launch process
# the parameter tree comes from the generative model tests
parameterTree$applyToParameterTree(
	foo=applyAlgorithmsToParameterTree, 
	algorithms=algos
)
