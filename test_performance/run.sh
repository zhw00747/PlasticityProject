#/bin/bash

CC=icpx
CC=g++

FLAGS="-O3 -march=native"


#$CC - main.o main.cpp $FLAGS
$CC -S vectorized.cpp $FLAGS
$CC -S impl.cpp $FLAGS

# $CC -o exe main.o impl.o $FLAGS

$CC -o exe main.cpp impl.cpp vectorized.cpp $FLAGS
./exe
rm -f *.o exe