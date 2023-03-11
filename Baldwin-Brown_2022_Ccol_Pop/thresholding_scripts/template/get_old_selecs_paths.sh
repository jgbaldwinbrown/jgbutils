#!/bin/bash
set -e

find `cat old_selecs_dir_path.txt` -name '*coeff*win1k*.txt*' | sort > old_selecs_1k_paths.txt
