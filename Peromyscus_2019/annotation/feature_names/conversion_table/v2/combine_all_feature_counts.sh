#!/bin/bash

ffile=`head -n 1 $1`

head -n 2 $ffile | tail -n 1 

cat $1 | while read i
do
    tail -n +3 $i
done
