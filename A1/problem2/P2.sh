#!/bin/bash

flex P2.l;
g++ lex.yy.c -ll;
if [[ $# != 1 ]] && [[ $# != 2 ]];
then
    echo "File should be used with either 1 or 2 arguments (of file name)"
    echo "Exiting..."
    exit 1
fi
if [ $# -eq 2 ]; 
then
    ./a.out < $1 > $2
else
    ./a.out < $1 > $1.csv
fi