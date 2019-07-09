###############################################################################
## This class implements the ConfInfoMap algorithm of Rosvall and Bergstrom:
##	- Rosvall, M. & Bergstrom, C. T. 
##	  Mapping change in large networks 
##	  PLos One, 2010, 5, e8694.
##
## Parameters:
##	- seed: a value seeding the process (by default we use a random value).
##	- attempts: number of attempts to partition the network.
##	- bootstrap: size of the bootstrap sample.
##	- conflev: confidence level for the significance analysis.
## Input:
##	- a pajek network
## 	- weighted: the network must absolutely be weighted (actual weights, not a vector of 1s)
##	- directed or undirected: a version of the algorithm is dedicated to directed networks, 
##	  and another one to undirected networks.
## Output:
##	- Mutually exclusive communities.
## 	- It outputs some temporary files which are deleted at the end of the process:
##		- .map: file for the MapEquation software (cf. http://www.mapequation.org)
##		- .smap: significance analysis of the best partition (among all attempts)
##		  can be used by the alluvial generator, same address.
##	  
## Use:
## 	- This implementation is in C++ language and may requires to recompile
## 	  the source. From the console, just go to the algorithms/infomap/(un)directed folders and type:
##				make
## 	  each folder should now contain an executable file "confinfomap.out".
## 	- Implementation retrived from http://www.tp.umu.se/~rosvall/code.html 
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorExternalConfinfomap <- setRefClass("CommunityDetectorExternalConfinfomap",
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
			
			internalName <<- "CONFINFOMAP"
			fileName <<- "confinfomap"
			plotText <<- "ConfInfoMap"
			
			networkOutFormat <<- NetworkFormatPajek$new()
			comstructInFormat <<- ComstructFormatRosvallBergstromMap$new()
			
#			.self$lock("internalName", "fileName", "plotText")
		},
			
		## Apply the algorithm to a network. 
		## It must absolutly be be weighted, or the algorithm won't apply.
		## Actual weights, not just forced 1s.
		## The network can be directed or undirected.
		##
		## @param network
		##		The network to be processed.
		## @param baseFolder
		##		Folder containing the network file (used for conversion).
		## @param considerDirections
		##		Whether or not directions should be used while detecting communities.
		## @param seed
		##		The value used to initialize the process.
		##		By default, it is randomly drawn.
		## @param attempts
		##		Number of attempts to partition the network.
		## @param bootstrap
		##		Number of samples used during the bootstrap step.
		## @param confLevel
		##		Confidence level used to assess the node membership significances.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder,
			considerDirections, 
			seed, attempts=10, bootstrap=100, confLevel=0.9)
		{	# checks if directions should be ignored
			network <- adaptNetworkDirections(network=network, wantsDirections=considerDirections)
			
			# checks if weights should be ignored
			if(!is.weighted(network))
				warning("CommunityDetectorExternalConfinfomap$detectCommunities: the links must absolutly be weighted for this algorithm.")
			
			# record the network to the appropriate format
			inputFile <- recordNetwork(network=network, baseFolder=baseFolder)
			
			# define output file names
			baseName <- getFileBasename(inputFile)
			mapFile <- paste(baseName,".map",sep="")
			smapFile <- paste(baseName,".smap",sep="")
			consoleFile <- paste(baseName,".confinfomap.console.temp",sep="")

			# init parameters
			if(missing(seed))
				seed <- round(runif(1,min=1,max=100000))
			
			# set command
			commandPath <- "Ganetto/detection/confinfomap/program"
			if(considerDirections)
				commandPath <- paste(commandPath,"/directed",sep="")
			else
				commandPath <- paste(commandPath,"/undirected",sep="")
			commandStr <- paste(commandPath ,"/conf-infomap.out ",seed," ",inputFile," ",
				attempts," ", bootstrap," ", confLevel, sep="")
			if(hideConsole)
				commandStr <- paste(commandStr," > ",consoleFile,sep="")
			
			# detect communities
			system(command=commandStr)
			
			# load the resulting membership vector as a Comstruct object
			if(file.exists(mapFile))
			{	partition <- comstructInFormat$readComstruct(mapFile)
				# convert to a Comstruct list
				result <- list(partition)
			}
			else
				# in case of error in the external program
				result <- list()
			
			
			# remove the temp files
			if(file.exists(mapFile))
				file.remove(mapFile)
			if(file.exists(smapFile))
				file.remove(smapFile)
			if(file.exists(consoleFile))
				file.remove(consoleFile)
			if(removeConversion && file.exists(inputFile))
				file.remove(inputFile)
			
			return(result)
		}
	)
)
