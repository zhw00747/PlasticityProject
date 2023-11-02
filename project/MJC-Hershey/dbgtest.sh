
clear
FC=ifort
FC=gfortran
$FC testprogram.f -o dbgt -Wall
./dbgt
rm dbgt