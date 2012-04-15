/* testStd.c                                  */
/* Test speed of the standard rand() function */
/* Richard J. Wagner  5 May 2000              */

/* This is free, unrestricted software void of any warranty. */

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

long i;
unsigned long junk;
clock_t startClock;
clock_t stopClock;

int main(void)
{
	printf( "Testing speed of standard rand() function\n" );
	printf( "\nTest of time to generate 300 million random integers:\n" );
	srand( 4357U );
	startClock = clock();
	for( i = 0; i < 3e+8; ++i )
	{
		junk = rand();
	}
	stopClock = clock();
	printf( "Time elapsed = " );
	printf( "%8.3f", (double)( stopClock - startClock ) / CLOCKS_PER_SEC );
	printf( " s\n" );
	
	return 0;
}

