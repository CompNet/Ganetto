all: example testWagner

debug: exampleD testWagnerD

example: example.cpp MersenneTwister.h
	g++ -Wall -ansi -o example example.cpp

exampleD: example.cpp MersenneTwister.h
	g++ -Wall -ansi -g -o exampleD example.cpp

testWagner: testWagner.cpp MersenneTwister.h
	g++ -O3 -Wall -ansi -o testWagner testWagner.cpp

testWagnerD: testWagner.cpp MersenneTwister.h
	g++ -g -Wall -o testWagnerD testWagner.cpp

testHinsch: testHinsch.cpp mtrand.h mtrand.cc
	g++ -O3 -Wall -o testHinsch testHinsch.cpp mtrand.cc

testOrigInt: testOrigInt.c mt19937int.c
	gcc -O3 -o testOrigInt testOrigInt.c

testOrig-1: testOrig-1.c mt19937-1.c
	gcc -O3 -o testOrig-1 testOrig-1.c

testOrig-2: testOrig-2.c mt19937-2.c
	gcc -O3 -o testOrig-2 testOrig-2.c

testCokus: testCokus.c cokus.c
	gcc -O3 -o testCokus testCokus.c

testGlib:
# testGlib: testGlib.c
# 	gcc -O3 -o testGlib testGlib.c

testStd: testStd.c
	gcc -O3 -o testStd testStd.c

test: testWagner testHinsch testOrigInt testOrig-1 testOrig-2 testCokus testGlib testStd
	@ echo "Testing output and speed of random number generators, please be patient..."
	./testWagner > testWagner.out
	./testHinsch > testHinsch.out
	./testOrigInt > testOrigInt.out
	./testOrig-1 > testOrig-1.out
	./testOrig-2 > testOrig-2.out
	./testCokus > testCokus.out
#	./testGlib > testGlib.out
	./testStd > testStd.out
	./testResults.sh
	@ rm -f tmp*

clean:
	@ rm -f test*.out bug.out
	@ rm -f testMT example exampleD testWagner testWagnerD testHinsch
	@ rm -f testOrigInt testOrig-1 testOrig-2 testCokus testGlib testStd
	@ rm -f tmp*
	@ rm -f state.data
	@ rm -f core
