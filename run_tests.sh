#!/bin/bash

flex TopDownRecursiveParser.lex
gcc lex.yy.c -ll
./a.out < grammar_test_1.in

if [ "$?" -eq 1 ]
then
    echo "YES! It's wrong"
fi