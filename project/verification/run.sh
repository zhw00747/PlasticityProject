#!/bin/bash
clear
init_abaqus_subroutine

# job="unit_shear"
# job="unit_exp"
job=$1

flags="job=$job user=vumat.f double int ask_delete=off"

echo "Command: abaqus "$flags
abaqus $flags

rm -f *.com *.mdl *.pac *.res *.stt *.src *.sel *.mdl *.prt *.abq *.exception *.msg

