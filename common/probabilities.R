###############################################################################
## This file contains functions used for randomly drawing values, according
## to various probabilistic distributions.
##
## @author Vincent Labatut
## @version 3
###############################################################################


## Processes a random integer between min and max,
## using a uniform distribution.
##
## @param min
##		The inf bound.
## @param max
##		The sup bound.
## @returns
##		An integer between min and max.
rdm <- function(min=1, max)
{	result <- ceiling(runif(1,min=(min-1),max=max));
	if(result < min)
		result <- min
	return(result);
}

## Generates a sample following a power-law distribution.
## Reference: http://mathworld.wolfram.com/RandomNumber.html
##
## @param n
##		Sample size.
## @param expnt
##		Power-law exponent.
## @param xmin
##		Lower bound.
## @param xmax
##		Upper bound.
## @returns
##		n floats ranging from xmin to xmax.
rpower <- function(n=1000,expnt=3,xmin=1,xmax=1000)
{	result <- ((xmax^(-expnt+1)-xmin^(-expnt+1))*runif(n)+xmin^(-expnt+1))^(1/(-expnt+1));
	return(result)
}
