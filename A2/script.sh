#!/bin/bash

bison -d A2.y
flex A2.l
g++ A2.tab.c lex.yy.c -lfl
./a.out < s.txt