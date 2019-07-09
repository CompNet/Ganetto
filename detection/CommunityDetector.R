###############################################################################
## This abstract class allows representing community detection algorithms,
## i.e. tools  able to identify community structures in networks.
## Each algorithm must be implemented/called in a class inheriting from this one.
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetector <- setRefClass("CommunityDetector",
		
# TODO TODO
# ne pas copier la meilleure coupe dans un dossier supplémentaire
# plutot : utiliser un fichier spécifique permettant de stocker
# la meilleure coupe pour chaque critère souhaité.

# TODO TODO
# nécessaire de gérer le calcul de perf directement ?
# >> non, à cause du re-calcul
	
	fields = list(
		## Name used internally to represent this algorithm.
		## This field is not modifiable.
		internalName="character",
		
		## Named used in filenames to represent this algorithm.
		## This field is not modifiable.
		fileName="character",
		
		## Text appearing in plots to represent this algorithm.
		## This field is not modifiable.
		plotText="character",
		
		## Indicates if all community structure levels should be recorded,
		## or only the best one.
		recordAllLevels="logical",
		
		## Format used to load the network.
		networkInFormat="NetworkFormat",
		
		## Format used to record community structures.
		comstructOutFormat="ComstructFormat",
		
		## ParameterTree used to store the algorithm parameters
		parameters="ParameterTree"
	),

	methods = list(
		## Receives the network to be processed and a set of parameters
		## taking the form of a parameter tree. The community detection
		## algorithm is applied to the network, possibly several times,
		## using all the parameter combinations specified in the ParameterTree.
		## Those parameters only concern the community detection, they
		## are independant from those used for the network generation
		## (or any other kind of parameter).
		##
		## The leaf ParameterNode parameter is compulsory, because
		## it is used for both input (loading the network) and output
		## (recording the community structure).
		##
		## The network is optional: if it is not specified, the leaf
		## parameter will be used to retrieve its location and load it.
		## In this case, it is necessary to have set the networkInFormat
		## field, though.
		##
		## Having  the network in memory is required for both
		## internal (obviously) and external approaches, because even
		## in the latter case, some conversions are often needed: this
		## allows speeding them up.
		##
		## @param leaf
		## 		The ParameterNode indicating the network location.
		## @param network
		## 		The network to be processed (optional).
		applyAlgorithmToParameterTree = function(leaf, network)
		{	# possibly create the local parameter tree
			if(length(parameters)==0)
				parameters <<- ParameterTree$new()
			
			# init the ParameterTree
			basePath <- leaf$getFullPath()
			basePath <- paste(basePath,"/algo=",fileName,sep="")
			parameters$folderPath <<- basePath
			
			# load the network if necessary
			if(missing(network) || is.na(network))
			{	# complete the available path
				fullPath <- networkInFormat$completeFullPath(fullPath=basePath,
					folderCheck=TRUE, extCheck=TRUE)
				# load the network
				network <- networkInFormat$readNetwork(fullPath)
			}
			
			# silently apply the algorithm to all combinations of parameters
			parameters$applyToParameterTree(foo=.self$applyAlgorithmToLeaf, network=network, mute=TRUE)
		},
		
		## Applies the community detection algorithm using the parameters
		## conveyed by the ParameterNode object (leaf), then record
		## the resulting communities in the appropriate file structure.
		##
		## @param leaf
		##		The ParameterNode object conveying the algorithm parameters.
		## @network
		##		The Network to be processed.
		## @param mute
		##		Optional parameter allowing to prevent returning the network
		##		and community structure, in case it is not needed.
		## @returns
		##		The list of detected community structures (if mute is not set to TRUE).
		applyAlgorithmToLeaf = function(leaf, network, mute=FALSE)
		{	# detect the communities
			paramValues <- leaf$getParameterValues()
			paramValues$network <- network
			paramValues$baseFolder <- leaf$getBasePath()
			communities <- do.call(what=.self$detectCommunities, args=paramValues)
			
			# generate the corresponding files
			folderPath <- leaf$getFullPath()
			recordCommunities(communities=communities, folderPath=folderPath)
			
			# finalize result
			if(mute)
				communities <- NULL
			return(communities)
		},
		
		## Abstract method allowing to apply the community detection algorithm.
		detectCommunities = function(network, ...)
		{	return(NULL)
		},
		
		## Records all the communities contained in the 'communities' list,
		## in files located in the 'folderPath' folder.
		## 
		## @param communities
		##		A list of Comstruct objects.
		## @param folderPath
		##		The folder to contain the community files.
		recordCommunities = function(communities, folderPath)
		{	if(length(communities)==0)
				warning("CommunityDetector$recordCommunities: the community structure is empty.")
			
			else
			{	# record each community structures
				for(c in 1:length(communities))
				{	# get filename
					path <- paste(folderPath,"/","level=",c,sep="")
					checkFolder(path)
					fullPath <- comstructOutFormat$completeFullPath(path)
					
					# record community structure
					#cat(c,"/",length(communities),"\n")
					comstructOutFormat$writeComstruct(communities[[c]],fullPath)
				}
			}
		}
	)
)

# load related files
source("Ganetto/detection/Static.R")
source("Ganetto/detection/CommunityDetectorExternal.R")
source("Ganetto/detection/CommunityDetectorInternal.R")
