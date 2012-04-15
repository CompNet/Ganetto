###############################################################################
## 
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorExternal <- setRefClass("CommunityDetectorExternal",
	contains = "CommunityDetector",
		
	fields = list(
		## Format used to record the network.
		networkOutFormat="NetworkFormat",
		
		## Format used to load community structures.
		comstructInFormat="ComstructFormat",
		
		## Allows hidding the console output.
		hideConsole="logical",

		## Indicates if the network converted files should be erased after use.
		removeConversion="logical"
	),
		
	methods = list(
		## Converts an existing network to the appropriate format,
		## if needed. 
		##
		## @param network
		##		The network to (possibly) be converted. 
		## @param baseFolder
		##		Full path of the folder meant to contain the results
		##		of the community detection process.
		## @return
		##		The full path of the created network file.
		recordNetwork=function(network, baseFolder)
		{	# get the new file name
			baseFolder <- dirname(baseFolder)
			fullPath <- networkOutFormat$completeFullPath(fullPath=baseFolder, 
				folderCheck=TRUE, extCheck=TRUE, 
				directedVersion=is.directed(network), weightedVersion=is.weighted(network))
			
			# check if the file already exists
			if(!file.exists(fullPath))
			{	# otherwise, create it using the predefined output format
				networkOutFormat$writeNetwork(network=network, fullPath=fullPath)
			}
			
			return(fullPath)
		}
	)
)

##### load related files
# Rosvall/Bergstrom tools
source("Ganetto/detection/infomod/CommunityDetectorExternalInfomod.R")
source("Ganetto/detection/infomap/CommunityDetectorExternalInfomap.R")
source("Ganetto/detection/confinfomap/CommunityDetectorExternalConfinfomap.R")
source("Ganetto/detection/infohiermap/CommunityDetectorExternalInfohiermap.R")

