/* testCokus.c                      */
/* Test output and speed of cokus.c */
/* Richard J. Wagner  5 May 2000    */

/* This is free, unrestricted software void of any warranty. */

#include <stdio.h>
#include <time.h>
#include "cokus.c"

long i;
unsigned long junk;
clock_t startClock;
clock_t stopClock;

int main(void)
{
	printf( "Testing output and speed of cokus.c\n" );
	printf( "\nTest of random integer generation:\n" );
	seedMT( 4357U );
	for( i = 0; i < 1000; ++i )
	{
		printf( "%10lu ", randomMT() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	printf( "\nTest of time to generate 300 million random integers:\n" );
	seedMT( 4357U );
	startClock = clock();
	for( i = 0; i < 3e+8; ++i )
	{
		junk = randomMT();
	}
	stopClock = clock();
	printf( "Time elapsed = " );
	printf( "%8.3f", (double)( stopClock - startClock ) / CLOCKS_PER_SEC );
	printf( " s\n" );
	
	return 0;
}

