###############################################################################
## Tests the community structure formats used in Rosvall/Bergstrom apps.
##
## @author Vincent Labatut
## @version 3
###############################################################################

filePath <- paste(dataRoot,"/community",sep="")

###############################################################################
# tree file
## Codelength = 3.48419 bits.
#1:1:1 0.0384615 "7"
#1:1:2 0.0384615 "8"
#1:1:3 0.0384615 "9"
#1:2:1 0.0384615 "4"
#1:2:2 0.0384615 "5"
#2:1:1 0.0384615 "2"
#2:1:2 0.0384615 "3"
#2:2:1 0.0384615 "6"
#2:2:2 0.0384615 "1"
#2:2:3 0.0384615 "0"
#2:2:4:1 0.0384615 "10"
#2:2:4:2 0.0384615 "11"

#fullPath <- paste(filePath,"/test.tree",sep="")

# define format
#rosvallBergstromTree <- ComstructFormatRosvallBergstromTree$new()

# load hierarchical community structure
#comstruct <- rosvallBergstromTree$readComstruct(fullPath)
#print(comstruct)

###############################################################################
## map file
## modules: 4
## modulelinks: 4
## nodes: 16
## links: 20
## codelength: 3.32773
#*Directed
#*Modules 4
#1 "Node 13,..." 0.25 0.0395432
#2 "Node 5,..." 0.25 0.0395432
#3 "Node 9,..." 0.25 0.0395432
#4 "Node 1,..." 0.25 0.0395432
#*Nodes 16
#1:1 "12" 0.0820133
#1:2 "13" 0.0790863
#1:3 "15" 0.0459137
#1:4 "14" 0.0429867
#2:1 "4" 0.0820133
#2:2 "5" 0.0790863
#2:3 "7" 0.0459137
#2:4 "6" 0.0429867
#3:1 "8" 0.0820133
#3:2 "9" 0.0790863
#3:3 "11" 0.0459137
#3:4 "10" 0.0429867
#4:1 "0" 0.0820133
#4:2 "1" 0.0790863
#4:3 "3" 0.0459137
#4:4 "2" 0.0429867
#*Links 4
#1 4 0.0395432
#2 3 0.0395432
#3 1 0.0395432
#4 2 0.0395432

fullPath <- paste(filePath,"/test.map",sep="")

# define format
rosvallBergstromMap <- ComstructFormatRosvallBergstromMap$new()

# load hierarchical community structure
comstruct <- rosvallBergstromMap$readComstruct(fullPath)
print(comstruct)
