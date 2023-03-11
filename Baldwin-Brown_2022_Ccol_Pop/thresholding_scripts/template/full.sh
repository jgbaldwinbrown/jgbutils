#!/bin/bash
set -e

bash get_old_selecs_paths.sh
bash prep_all.sh
bash pfst_fst_selec_list.sh
bash bedify_selec.sh
bash multiplots.sh
bash multiplots_pfst_fst_selec.sh
bash intersect_pfst_fst_selec.sh
bash run_thresh_rvr.sh
bash run_thresh.sh
bash run_gggenes.sh
bash run_lfmt.sh
bash run_ts_max_cat.sh
bash run_full_multimax.sh
bash qqplot_all.sh
