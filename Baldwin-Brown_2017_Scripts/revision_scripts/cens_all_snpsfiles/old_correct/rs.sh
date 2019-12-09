#!/bin/bash

set -e

rsync -avP . jbaldwin@wfitch.bio.uci.edu:/home/jbaldwin/new_home/temp_for_hpc/old_correct
