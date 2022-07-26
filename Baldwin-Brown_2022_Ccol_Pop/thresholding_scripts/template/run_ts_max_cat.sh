#!/bin/bash
set -e

echo "minisync.sync	minigggenes_out2_thresholded_intervals.bed	infos/black_pooled_info_ne_bitted.txt	minimax	minimaxcat" > mini_sbi.txt
multi_max_slope_categories <mini_sbi.txt > multimaxes.txt
