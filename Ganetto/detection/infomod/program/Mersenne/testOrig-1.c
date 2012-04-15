/* testOrig-1.c                  */
/* Test output of mt19937-1.c    */
/* Richard J. Wagner  5 May 2000 */

/* This is free, unrestricted software void of any warranty. */

#include <stdio.h>
#include <time.h>
#include "mt19937-1.c"

long i;

int main(void)
{
	printf( "Testing output and speed of mt19937-1.c\n" );
	printf( "\nTest of random real number [0,1] generation:\n" );
	sgenrand( 4357U );
	for( i = 0; i < 1000; ++i )
	{
        printf( "%10.8f ", genrand() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	return 0;
}

