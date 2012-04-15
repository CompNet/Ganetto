###############################################################################
## This class implements the InfoMod algorithm defined by
## 	- Rosvall, M. & Bergstrom, C. T. 
##	  An information-theoretic framework for resolving community structure in complex networks 
##	  Proceedings of the National Academy of Sciences, 2007, 104, 7327-7331
##
## Parameters:
##	- seed: a value seeding the process (by default we use a random value)
##	- attempts: number of attempts to partition the network
## Input:
##	- a pajek network
## 	- unweighted only
##	- undirected only
## Output:
##	- Mutually exclusive communities
## 	- It outputs two temporary files which are deleted (a .clu and a .mod pajek files)
##	  Only the .clu file is used to retrieve the community structure. 
## Use:
## 	- This implementation is in C++ language and may requires to recompile
## 	  the source. From the console, just go to the algorithms/infomod folder and type:
##				make
## 	  An executable file "infomod.out" should then be created.
##	  WARNING: there was a few errors preventing from handling paths containing 
##	  the character '.'. The corrections are indicated in the C++ source code 
##	  with "TODO" tags.
## 	- Implementation retrived from: http://www.tp.umu.se/~rosvall/code.html
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorExternalInfomod <- setRefClass("CommunityDetectorExternalInfomod",
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
			
			internalName <<- "INFOMOD"
			fileName <<- "infomod"
			plotText <<- "InfoMod"
			
			networkOutFormat <<- NetworkFormatPajek$new(directed=FALSE, weighted=FALSE)
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
		## @param considerWeights
		##		Whether or not weights should be used while detecting communities.
		## @param seed
		##		The value used to initialize the process.
		##		By default, it is randomly drawn.
		## @param attempts
		##		Number of attempts to partition the network.
		## @return
		##		A list of Comstruct objects corresponding to the detected
		##		community structures.
		detectCommunities = function(network, baseFolder, 
			considerWeights, 
			seed, attempts=10)
		{	# link directions are always ignored
			network <- adaptNetworkDirections(network=network, wantsDirections=FALSE)
			
			# checks if weights should be ignored
			network <- adaptNetworkWeights(network=network, wantsWeights=considerWeights)
			
			# record the network to the appropriate format
			inputFile <- recordNetwork(network=network, baseFolder=baseFolder)
			
			# define output file names
			baseName <- getFileBasename(inputFile)
			partitionFile <- paste(baseName,".clu",sep="")
			moduleFile <- paste(baseName,".mod",sep="")
			consoleFile <- paste(baseName,".infomod.console.temp",sep="")
			
			# init parameters
			if(missing(seed))
				seed <- round(runif(1,min=1,max=100000))
	
			# set command
			commandPath <- "Ganetto/detection/infomod/program"
			commandStr <- paste(commandPath ,"/infomod.out ",seed," ",inputFile," ",attempts,sep="")
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
			if(file.exists(partitionFile))
				file.remove(partitionFile)
			if(file.exists(moduleFile))
				file.remove(moduleFile)
			if(file.exists(consoleFile))
				file.remove(consoleFile)
			if(removeConversion && file.exists(inputFile))
				file.remove(inputFile)
			
			return(result)
		}
	)
)
