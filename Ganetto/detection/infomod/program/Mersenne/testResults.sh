#!/bin/sh

# testResults.sh
# Examine the output from test of random number generators
# Explain the meaning in plain English

grep -A 200 "integer generation:" testWagner.out | tail -200 > tmpWagnerInt.out
grep -A 200 -F "[0,1] generation:" testWagner.out | tail -200 > tmpWagner-1.out
grep -A 200 -F "[0,1) generation:" testWagner.out | tail -200 > tmpWagner-2.out
grep -A 200 "integer generation:" testOrigInt.out | tail -200 > tmpOrigInt.out
grep -A 200 -F "[0,1] generation:" testOrig-1.out | tail -200 > tmpOrig-1.out
grep -A 200 -F "[0,1) generation:" testOrig-2.out | tail -200 > tmpOrig-2.out

rm -f tmpDiffLocal.out tmpDiffRef.out tmpError.out

diff --brief tmpWagnerInt.out tmpOrigInt.out | tee -a tmpDiffLocal.out
diff --brief tmpWagner-1.out tmpOrig-1.out | tee -a tmpDiffLocal.out
diff --brief tmpWagner-2.out tmpOrig-2.out | tee -a tmpDiffLocal.out

diff -b --brief tmpWagnerInt.out mt19937int.out | tee -a tmpDiffRef.out
diff -b --brief tmpWagner-1.out mt19937-1.out | tee -a tmpDiffRef.out
diff -b --brief tmpWagner-2.out mt19937-2.out | tee -a tmpDiffRef.out

grep "Error" testWagner.out | tee tmpError.out

echo
echo "Rate of Mersenne Twister random integer generation:"
printf "    MersenneTwister.h (this C++ class) "
gawk '/Time elapsed/{ printf( "%4.1f million per second\n", 300 / $4 ) }' testWagner.out
printf "    Original C version                 "
gawk '/Time elapsed/{ printf( "%4.1f million per second\n", 300 / $4 ) }' testOrigInt.out
printf "    Cokus's optimized C version        "
gawk '/Time elapsed/{ printf( "%4.1f million per second (non-standard seeding)\n", 300 / $4 ) }' testCokus.out
printf "    Hinsch's C++ class                 "
gawk '/Time elapsed/{ printf( "%4.1f million per second (non-standard seeding)\n", 300 / $4 ) }' testHinsch.out
printf "    Standard rand()                    "
gawk '/Time elapsed/{ printf( "%4.1f million per second (non-MT)\n", 300 / $4 ) }' testStd.out
echo

failLocal=false
failRef=false
if [ -s tmpDiffLocal.out ]; then
	failLocal=true
fi
if [ -s tmpDiffRef.out ] || [ -s tmpError.out ]; then
	failRef=true
fi
if [ $failLocal = "true" ] || [ $failRef = "true" ]; then
	if [ $failRef = "true" ]; then
		cat testWagner.out testOrigInt.out testOrig-1.out testOrig-2.out > bug.out
		echo "Failed tests - MersenneTwister.h generated incorrect output"
		echo "Results have been written to a file called 'bug.out'"
		echo "Please send a copy of 'bug.out' and system info to rjwagner@writeme.com"
	else
		echo "Original C version failed"
		echo "MersenneTwister.h passed and is safe to use"
	fi
else
	echo "Passed all tests"
fi

exit 0
