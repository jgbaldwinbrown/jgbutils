#!/bin/bash
set -e

SWD=`pwd`

# bash basic_calc.sh
# 
# cd "${SWD}/ann" && {
#     bash full.sh
# }
# 
# cd "${SWD}/ann/gene_density" && {
#     bash true_full.sh
# }

cd "${SWD}/cumcov_plot/v2" && {
    bash make_final.sh
}


cd "${SWD}/gene_reduction/baccut" && {
    bash full.sh
}

cd "${SWD}/synteny/run6_alt_trans_baccut" && {
    bash full.sh
}

