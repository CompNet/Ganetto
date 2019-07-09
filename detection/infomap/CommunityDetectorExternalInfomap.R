###############################################################################
## This class implements the InfoMap algorithm of Rosvall and Bergstrom:
##	- Rosvall, M. & Bergstrom, C. T. 
##	  Maps of random walks on complex networks reveal community structure
##	  Proceedings of the National Academy of Sciences, 2008, 105, 1118.
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
##				 Not the most interesting file for us.
##		- .map: file for the MapEquation software (cf. http://www.mapequation.org)
##		- .clu: partition at the Pajek format: this is the file used to retrieve
##				the community structure.
##		- _map.net: Pajek network whose nodes are aggregated depending on the obtained map (network of communities)
##		- _map.vec: Pajek vector containing the community sizes.
##	  
## Use:
## 	- This implementation is in C++ language and may requires to recompile
## 	  the source. From the console, just go to the algorithms/infomap/(un)directed folders and type:
##				make
## 	  each folder should now contain an executable file "infomap.out".
## 	- Implementation retrived from http://www.tp.umu.se/~rosvall/code.html 
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorExternalInfomap <- setRefClass("CommunityDetectorExternalInfomap",
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
			
			internalName <<- "INFOMAP"
			fileName <<- "infomap"
			plotText <<- "InfoMap"
			
			networkOutFormat <<- NetworkFormatPajek$new()
			comstructInFormat <<- ComstructFormatPajek$new()
			
#			.self$lock("internalName", "fileName", "plotText")
		},
		
		## Apply the algorithm to a network. 
		## It must be undirected, but it can be weighted or unweighted.
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
		## @param considerSelfLinks
		##		If TRUE, the algorithm will take self-links (links between one
		##		node and itself) into account. This parameter is only considered
		##		if considerDirections is also TRUE.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder,
				considerDirections, considerWeights, 
				seed, attempts=10, considerSelfLinks=FALSE)
		{	# checks if directions should be ignored
			network <- adaptNetworkDirections(network=network, wantsDirections=considerDirections)
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# record the network to the appropriate format
			inputFile <- recordNetwork(network=network, baseFolder=baseFolder)
			
			# define output file names
			baseName <- getFileBasename(inputFile)
			treeFile <- paste(baseName,".tree",sep="")
			partitionFile <- paste(baseName,".clu",sep="")
			mapFile <- paste(baseName,".map",sep="")
			mapNetFile <- paste(baseName,"_map.net",sep="")
			mapVecFile <- paste(baseName,"_map.vec",sep="")
			consoleFile <- paste(baseName,".infomap.console.temp",sep="")
			
			# init parameters
			if(missing(seed))
				seed <- round(runif(1,min=1,max=100000))
			
			# set command
			commandPath <- "Ganetto/detection/infomap/program"
			if(considerDirections)
				commandPath <- paste(commandPath,"/directed",sep="")
			else
				commandPath <- paste(commandPath,"/undirected",sep="")
			commandStr <- paste(commandPath ,"/infomap.out ",seed," ",inputFile," ",attempts,sep="")
			if(considerSelfLinks && considerDirections)
				commandStr <- paste(commandStr," selflink",sep="")
			if(hideConsole)
				commandStr <- paste(commandStr," > ",consoleFile,sep="")
			
			# detect communities
			system(command=commandStr)
			
			# load the resulting membership vector as a Comstruct object
			if(file.exists(partitionFile))
			{	partition <- comstructInFormat$readComstruct(partitionFile)
				# convert to a Comstruct list
				result <- list(partition)
			}
			else
				# in case of error in the external program
				result <- list()
			
			
			# remove the temp files
			if(file.exists(treeFile))
				file.remove(treeFile);
			if(file.exists(partitionFile))
				file.remove(partitionFile)
			if(file.exists(mapFile))
				file.remove(mapFile)
			if(file.exists(mapNetFile))
				file.remove(mapNetFile)
			if(file.exists(mapVecFile))
				file.remove(mapVecFile)
			if(file.exists(consoleFile))
				file.remove(consoleFile)
			if(removeConversion && file.exists(inputFile))
				file.remove(inputFile)
			
			return(result)
		}
	)
)
