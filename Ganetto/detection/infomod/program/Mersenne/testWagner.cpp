// testWagner.cpp
// Test output and speed of MersenneTwister.h
// Richard J. Wagner  12 July 2001

// This is free, unrestricted software void of any warranty.

#include <stdio.h>
#include <time.h>
#include <fstream>
#include "MersenneTwister.h"

int main(void)
{
	printf( "Testing output and speed of MersenneTwister.h\n" );
	printf( "\nTest of random integer generation:\n" );
	MTRand mtrand1( 4357U );
	for( int i = 0; i < 1000; ++i )
	{
		printf( "%10lu ", mtrand1.randInt() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	printf( "\nTest of random real number [0,1] generation:\n" );
	MTRand mtrand2( 4357U );
	for( int i = 0; i < 1000; ++i )
	{
		printf( "%10.8f ", mtrand2.rand() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	printf( "\nTest of random real number [0,1) generation:\n" );
	MTRand mtrand3( 4357U );
	for( int i = 0; i < 1000; ++i )
	{
		printf( "%10.8f ", mtrand3.randExc() );
		if( i % 5 == 4 ) printf("\n");
	}
	
	printf( "\nTest of time to generate 300 million random integers:\n" );
	MTRand mtrand4( 4357U );
	unsigned long junk;
	clock_t startClock = clock();
	for( long i = 0; i < 3e+8; ++i )
	{
		junk = mtrand4.randInt();
	}
	clock_t stopClock = clock();
	printf( "Time elapsed = " );
	printf( "%8.3f", double( stopClock - startClock ) / CLOCKS_PER_SEC );
	printf( " s\n" );
	
	
	printf( "\nTests of functionality:\n" );
	
	// Array save/load test
	bool saveArrayFailure = false;
	MTRand mtrand5;
	unsigned long pass1[5], pass2[5];
	MTRand::uint32 saveArray[ MTRand::SAVE ];
	mtrand5.save( saveArray );
	for( int i = 0; i < 5; ++i )
		pass1[i] = mtrand5.randInt();
	mtrand5.load( saveArray );
	for( int i = 0; i < 5; ++i )
	{
		pass2[i] = mtrand5.randInt();
		if( pass2[i] != pass1[i] )
			saveArrayFailure = true;
	}
	if( saveArrayFailure )
		printf( "Error - Failed array save/load test\n" );
	else
		printf( "Passed array save/load test\n" );
	
	
	// Stream save/load test
	bool saveStreamFailure = false;
	std::ofstream dataOut( "state.data" );
	if( dataOut )
	{
		dataOut << mtrand5;  // comment out if compiler does not support
		dataOut.close();
	} 
	for( int i = 0; i < 5; ++i )
		pass1[i] = mtrand5.randInt();
	std::ifstream dataIn( "state.data" );
	if( dataIn )
	{
		dataIn >> mtrand5;  // comment out if compiler does not support
		dataIn.close();
	}
	for( int i = 0; i < 5; ++i )
	{
		pass2[i] = mtrand5.randInt();
		if( pass2[i] != pass1[i] )
			saveStreamFailure = true;
	}
	if( saveStreamFailure )
		printf( "Error - Failed stream save/load test\n" );
	else
		printf( "Passed stream save/load test\n" );
	
	
	// Integer range test
	MTRand mtrand6;
	bool integerRangeFailure = false;
	bool gotMax = false;
	for( int i = 0; i < 10000; ++i )
	{
		int r = mtrand6.randInt(17);
		if( r < 0 || r > 17 )
			integerRangeFailure = true;
		if( r == 17 )
			gotMax = true;
	}
	if( !gotMax )
		integerRangeFailure = true;
	if( integerRangeFailure )
		printf( "Error - Failed integer range test\n" );
	else
		printf( "Passed integer range test\n" );
	
	
	// Float range test
	MTRand mtrand7;
	bool floatRangeFailure = false;
	for( int i = 0; i < 10000; ++i )
	{
		float r = mtrand7.rand(0.3183);
		if( r < 0.0 || r > 0.3183 )
			floatRangeFailure = true;
	}
	if( floatRangeFailure )
		printf( "Error - Failed float range test\n" );
	else
		printf( "Passed float range test\n" );
	
	
	// Auto-seed uniqueness test
	MTRand mtrand8a, mtrand8b, mtrand8c;
	double r8a = mtrand8a();
	double r8b = mtrand8b();
	double r8c = mtrand8c();
	if( r8a == r8b || r8a == r8c || r8b == r8c )
		printf( "Error - Failed auto-seed uniqueness test\n" );
	else
		printf( "Passed auto-seed uniqueness test\n" );
	
	return 0;
}
