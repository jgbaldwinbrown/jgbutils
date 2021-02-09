#!/bin/bash
set -e

head -n 1 aeds.txt > aeds_sorted.txt
tail -n +2 aeds.txt | \
sort -k 3,3n \
>> aeds_sorted.txt
