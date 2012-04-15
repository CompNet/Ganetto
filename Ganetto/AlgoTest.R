## setwd("~/eclipse/workspaces/Networks")
## source("Ganetto/AlgoTest.R")


folderPath <- "/var/data/algotest/n=2.15/x=12345"
dirNetworkPath <- paste(folderPath,"/network.directed.net",sep="")
undirNetworkPath <- paste(folderPath,"/network.undirected.net",sep="")

#cmd <- paste("CommunityDetection/algorithms/infomod/infomod.out 12345 ",dirNetworkPath," 3",sep="")

#cmd <- paste("Ganetto/detection/infomap/program/directed/infomap.out 12345 ",dirNetworkPath," 3",sep="")
#cmd <- paste("Ganetto/detection/infomap/program/undirected/infomap.out 12345 ",undirNetworkPath," 3",sep="")

#cmd <- paste("Ganetto/detection/infohiermap/program/directed/infomap.out 12345 ",dirNetworkPath," 3",sep="")
#cmd <- paste("Ganetto/detection/infohiermap/program/undirected/infohiermap.out 12345 ",undirNetworkPath," 10",sep="")

#cmd <- paste("Ganetto/detection/confinfomap/program/directed/conf-infomap.out 12345 ",dirNetworkPath," 3 25 0.9",sep="")
#cmd <- paste("Ganetto/detection/confinfomap/program/undirected/conf-infomap.out 12345 ",undirNetworkPath," 3 25 0.9",sep="")

system(command=cmd)
