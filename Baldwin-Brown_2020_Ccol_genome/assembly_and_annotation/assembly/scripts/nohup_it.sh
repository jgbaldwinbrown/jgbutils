#!/bin/bash
echo "$@" | tr ' ' '\n' | while read i
do
nohup make -k -j $i 1>> nohup_${i}_out.txt 2>> nohup_${i}_err.txt &
done
