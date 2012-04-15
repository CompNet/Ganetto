# Various flags

CXX  = g++
LINK = $(CXX)
#CXXFLAGS = -I Mersenne -Wall -g 
CXXFLAGS = -I Mersenne -Wall -O3 -funroll-loops -pipe
LFLAGS = -lm


TARGET  = infomod.out

HEADER  = infomod.h GreedyBase.h Greedy.h Node.h
FILES = infomod.cc GreedyBase.cc Greedy.cc Node.cc

OBJECTS = $(FILES:.cc=.o)

$(TARGET): ${OBJECTS}
	$(LINK) $^ $(LFLAGS) -o $@

all: $(TARGET)

clean:
	rm -f $(OBJECTS)

distclean:
	rm -f $(OBJECTS) $(TARGET)

# Compile and dependency
$(OBJECTS): $(HEADER) Makefile




