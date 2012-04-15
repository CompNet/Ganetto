// testHinsch.cpp
// Test output and speed of mtrand.h
// Richard J. Wagner  5 May 2000

// This is free, unrestricted software void of any warranty.

#include <stdio.h>
#include <time.h>
#include "mtrand.h"

int main(void)
{
	printf( "Testing output and speed of mtrand.h\n" );
	printf( "\nTest of random integer generation:\n" );
	MTRand mtrand1;
	for( int i = 0; i < 1000; ++i )
	{
		printf( "%10lu ", mtrand1() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	printf( "\nTest of time to generate 300 million random integers:\n" );
	MTRand mtrand4;
	unsigned long junk;
	clock_t startClock = clock();
	for( long i = 0; i < 3e+8; ++i )
	{
		junk = mtrand4();
	}
	clock_t stopClock = clock();
	printf( "Time elapsed = " );
	printf( "%8.3f", double( stopClock - startClock ) / CLOCKS_PER_SEC );
	printf( " s\n" );
	
	return 0;
}

