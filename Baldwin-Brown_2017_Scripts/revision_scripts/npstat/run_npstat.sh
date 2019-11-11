#!/bin/bash
set -e

./npstat_multi.py <(gunzip -c inter/merged-realigned.mpileup.gz) -n 100 -l 2 > out/npstat_out.txt
