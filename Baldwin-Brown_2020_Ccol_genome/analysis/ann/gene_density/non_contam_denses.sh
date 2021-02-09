#!/bin/bash
set -e

cat answer.bed | datamash mean 4
cat repanswer.bed | datamash mean 4
