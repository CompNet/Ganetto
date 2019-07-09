###############################################################################
## setwd("~/eclipse/workspaces/Networks")
## setwd("c:/eclipse/workspaces/Networks")
## source("Ganetto/Main.R")
##
## http://manuals.bioinformatics.ucr.edu/home/programming-in-r#Progr_class
## http://www.stat.auckland.ac.nz/S-Workshop/Gentleman/S4Objects.pdf
## https://www.rmetrics.org/files/Meielisalp2009/Presentations/Chalabi1.pdf
## http://www.inside-r.org/r-doc/methods/ReferenceClasses
##
## @author Vincent Labatut
## @version 3
###############################################################################

options(error=dump.frames)

os <- .Platform$OS.type
if(os=="windows") dataRoot <- "c:/temp" else dataRoot <- "/var/data/algotest"


library(igraph)
source("Ganetto/common/collections.R")
source("Ganetto/common/constants.R")
source("Ganetto/common/files.R")
source("Ganetto/common/networks.R")
source("Ganetto/common/probabilities.R")
# misc tests
#source("Ganetto/common/testNetworks.R")

# parameter tree
source("Ganetto/parameter/Parameter.R")
#source("Ganetto/parameter/TestParameter.R")

# network formats
source("Ganetto/networkformat/NetworkFormat.R")
#source("Ganetto/networkformat/TestNetworkFormat.R")

# community structure
source("Ganetto/comstruct/Comstruct.R")
#source("Ganetto/comstruct/TestComstruct.R")

# community formats
source("Ganetto/comstructformat/ComstructFormat.R")
#source("Ganetto/comstructformat/TestComstructFormat1.R")
#source("Ganetto/comstructformat/TestComstructFormat2.R")

# generative models
source("Ganetto/generation/GenerativeModel.R")
source("Ganetto/generation/TestGenerativeModel.R")

# community detection
source("Ganetto/detection/CommunityDetector.R")
#source("Ganetto/detection/TestCommunityDetector0.R")
#source("Ganetto/detection/TestCommunityDetector1.R")
#source("Ganetto/detection/TestCommunityDetector2.R")
source("Ganetto/detection/TestCommunityDetector3.R")




# TODO com.det algos need an option allowing not output
# all hierarchical levels (when there are several ones)
# -> need to define a class to represent performance processing
#    and allow a com.det object to be set with it, and use
#	 it to select the best level on the fly.

# TODO
# set of community structures (multilevel):
#	> result-oriented representation
#	> list containing CommunityStructure objects
#	> possible to process the community of a node at each level
#	> store the best comstruct
#	> possible to store the measures used to select the best comstruct (eg. modularity)

# TODO
# all network transformations must also transform the community structure refernce file in case
# one wants to apply a community detection algo on the resulting network (eg giant component)

# TODO 
# each network "processing module" must have a "getFolderStructure" function which
# returns the updated parameter tree with all additional stuff. eg, com.det will
# add the algo name folder and level folders.
# processing modules: generators, filters, community detectors (each com is a new network)

# TODO
# LFR rewiring can be considered as a transformation.
# a transformation outputs a network and possibly an updated reference community structure
# (if there was one before before the transformation)
# line graphs is also a transformation (but without community structure (?)).

# TODO
# things to add eventually:
# - check how a comdet algo behaves when there're several components, 
#   and possibly force it to consider components as different levels
# - implement some repetitive process and merge the result to get stability
#	with very instable algos such as label propagation.

# TODO
# What to do with nodes without any community?
# should they be forced to NA in our internal representation,
# or counted as size-one communities?
# -> the first solution will cause problems when comparing comstructs
#    using partition-based methods.


warnings()

