###############################################################################
## This class implements the InfoHierMap algorithm of Rosvall and Bergstrom:
##	- Rosvall, M. & Bergstrom, C. T. 
##	  Multilevel compression of random walks on networks reveals hierarchical organization in large integrated systems 
##	  PLoS ONE, 2011, 6, e18209.
##
## Parameters:
##	- seed: a value seeding the process (by default we use a random value)
##	- attempts: number of attempts to partition the network
## Input:
##	- a pajek network
## 	- weighted or unweighted
##	- directed or undirected: a version of the algorithm is dedicated to directed networks, 
##	  and another one to undirected networks.
## Output:
##	- Mutually exclusive communities
## 	- It outputs some temporary files which are deleted at the end of the process:
##		- .tree: description of the best partition found.
##				 It's a custom format, the rows are of the form:
##		       	 community:node_index_in_community random_walker_population "node name"
##		- .map: file for the MapEquation software (cf. http://www.mapequation.org)
##				Actually, for some reason, those are generated only with the
##				undirected version of the algorithm.
##	  
## Use:
## 	- This implementation is in C++ language and may requires to recompile
## 	  the source. From the console, just go to the algorithms/infomap/(un)directed folders and type:
##				make
## 	  one folder should now contain an executable file "infomap.out" and
##	  the other "infohiermap.out".
## 	- Implementation retrived from http://www.tp.umu.se/~rosvall/code.html 
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorExternalInfohiermap <- setRefClass("CommunityDetectorExternalInfohiermap",
	contains = "CommunityDetectorExternal",
	
	methods = list(
		## Forces certain fields to take specific values.
		## This method is automatically called during object construction. 
		##
		## @param ...
		##		Attribute values specified by the user during construction.
		initialize = function(...)
		{	removeConversion <<- TRUE
			hideConsole <<- TRUE
			
			callSuper(...)
			
			internalName <<- "INFOHIERMAP"
			fileName <<- "infohiermap"
			plotText <<- "InfoHierMap"
			
			networkOutFormat <<- NetworkFormatPajek$new()
			comstructInFormat <<- ComstructFormatRosvallBergstromTree$new()
			
#			.self$lock("internalName", "fileName", "plotText")
		},
			
		## Apply the algorithm to a network. 
		## It can be directed or undirected,
		## and weighted or unweighted.
		##
		## @param network
		##		The network to be processed.
		## @param baseFolder
		##		Folder containing the network file (used for conversion).
		## @param considerDirections
		##		Whether or not directions should be used while detecting communities.
		## @param considerWeights
		##		Whether or not weights should be used while detecting communities.
		## @param seed
		##		The value used to initialize the process.
		##		By default, it is randomly drawn.
		## @param attempts
		##		Number of attempts to partition the network.
		## @param recursive
		##		Seems to be ignored, for now.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder,
			considerDirections, considerWeights, 
			seed, attempts=10, recursive)
		{	# checks if directions should be ignored
			network <- adaptNetworkDirections(network=network, wantsDirections=considerDirections)
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# record the network to the appropriate format
			inputFile <- recordNetwork(network=network, baseFolder=baseFolder)
			
			# define output file names
			baseName <- getFileBasename(inputFile)
			treeFile <- paste(baseName,".tree",sep="")
			mapBaseFile <- paste(baseName,"_level",sep="")
			consoleFile <- paste(baseName,".infohiermap.console.temp",sep="")
			
			# init parameters
			if(missing(seed))
				seed <- round(runif(1,min=1,max=100000))
			
			# set command
			commandPath <- "Ganetto/detection/infohiermap/program"
			if(considerDirections)
				commandPath <- paste(commandPath,"/directed/infomap",sep="")
			else
				commandPath <- paste(commandPath,"/undirected/infohiermap",sep="")
			commandStr <- paste(commandPath ,".out ",seed," ",inputFile," ",attempts,sep="")
			if(hideConsole)
				commandStr <- paste(commandStr," > ",consoleFile,sep="")
			
			# detect communities
			system(command=commandStr)
			
			# load the resulting hierarchy of community structures
			if(file.exists(treeFile))
				result <- comstructInFormat$readComstruct(treeFile)
			else
				# in case of error in the external program
				result <- list()
			
			# remove the temp files
			if(file.exists(treeFile))
				file.remove(treeFile)
			i <- 0
			mapFile <- paste(mapBaseFile,i,".map",sep="")
			while(file.exists(mapFile))
			{	file.remove(mapFile)
				i <- i + 1
				mapFile <- paste(mapBaseFile,i,".map",sep="")
			}
			if(file.exists(consoleFile))
				file.remove(consoleFile)
			if(removeConversion && file.exists(inputFile))
				file.remove(inputFile)
			
			return(result)
		}
	)
)
