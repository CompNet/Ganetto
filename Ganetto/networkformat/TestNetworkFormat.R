###############################################################################
## Tests the network formats functions and classes.
##
## @author Vincent Labatut
## @version 3
###############################################################################

# init
g <- simplify(barabasi.game(n=10,m=5))
print(ecount(g))
print(vcount(g))
filePath <- paste(dataRoot,"/network",sep="")

# define all formats
nfEdgelist <- NetworkFormatEdgelist$new()
nfGraphml <- NetworkFormatGraphml$new()
nfNodelist <- NetworkFormatNodelist$new()
nfPajek <- NetworkFormatPajek$new()
formats <- list(nfEdgelist,nfGraphml,nfNodelist,nfPajek)

# record natural formats
cat("\nrecording natural formats\n")
for(f in formats)
{	fullPath <- paste(filePath,".natural",f$getFileExt(),sep="")
	print(fullPath)
	
	f$writeNetwork(network=g, fullPath)
}

# same thing while forcing direction/weights
cat("\nrecording while forcing direction/weights\n")
for(directed in c(FALSE,TRUE))
{	for(weighted in c(FALSE,TRUE))
	{	for(f in formats)
		{	fullPath <- paste(filePath,".dir=",directed,".wei=",weighted,f$getFileExt(),sep="")
			print(fullPath)
			
			f$directed <- directed
			f$weighted <- weighted
			f$writeNetwork(network=g, fullPath)
		}
	}	
}

# re-define all formats
nfEdgelist <- NetworkFormatEdgelist$new()
nfGraphml <- NetworkFormatGraphml$new()
nfNodelist <- NetworkFormatNodelist$new()
nfPajek <- NetworkFormatPajek$new()
formats <- list(nfEdgelist,nfGraphml,nfNodelist,nfPajek)

# load natural formats
cat("\nloading natural formats\n")
for(f in formats)
{	fullPath <- paste(filePath,".natural",f$getFileExt(),sep="")
	print(fullPath)
	
	g <- f$readNetwork(fullPath)
	cat("directed: ",is.directed(g)," weighted: ",is.weighted(g),"\n",sep="")
}

# load thing while forcing direction/weights
cat("\nloading while forcing direction/weights\n")
for(directed in c(FALSE,TRUE))
{	for(weighted in c(FALSE,TRUE))
	{	for(f in formats)
		{	fullPath <- paste(filePath,".dir=",directed,".wei=",weighted,f$getFileExt(),sep="")
			print(fullPath)
			
			f$directed <- directed
			f$weighted <- weighted
			g <- f$readNetwork(fullPath)
			cat("directed: ",is.directed(g)," weighted: ",is.weighted(g),"\n",sep="")
		}
	}	
}
