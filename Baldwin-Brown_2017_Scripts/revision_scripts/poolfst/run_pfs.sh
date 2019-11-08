#!/bin/bash
set -e

Rscript ../poolfst/pfs.R
cp inter/fst.txt out
cp inter/full_fst.txt out
