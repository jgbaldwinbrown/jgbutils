#!/bin/bash
set -e

./npstat_multi.py inter/merged-realigned.mpileup -n 100 -l 2 > out/npstat_out.txt
