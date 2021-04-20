#!/bin/bash
set -e

bash train_augustus_busco.sh
bash run_setup.sh

(
    cd outs/louseref_nmask_long_copy2.fasta.gz_dir
    bash ../../merge.sh
)
