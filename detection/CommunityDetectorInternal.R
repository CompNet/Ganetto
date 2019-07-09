###############################################################################
## 
##
## @author Vincent Labatut
## @version 3
###############################################################################
CommunityDetectorInternal <- setRefClass("CommunityDetectorInternal",
	contains = "CommunityDetector",
		
	fields = list(
	),
		
	methods = list(
	)
)

# load related files
source("Ganetto/detection/edgebetweenness/CommunityDetectorInternalEdgebetweenness.R")
source("Ganetto/detection/fastgreedy/CommunityDetectorInternalFastgreedy.R")
source("Ganetto/detection/labelpropagation/CommunityDetectorInternalLabelpropagation.R")
source("Ganetto/detection/leadingeigenvector/CommunityDetectorInternalLeadingeigenvector.R")
source("Ganetto/detection/spinglass/CommunityDetectorInternalSpinglass.R")
source("Ganetto/detection/walktrap/CommunityDetectorInternalWalktrap.R")
