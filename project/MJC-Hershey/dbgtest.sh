
clear
FC=gfortran
FC=ifort
$FC testprogram.f -o dbgt -Wall
./dbgt
rm dbgt