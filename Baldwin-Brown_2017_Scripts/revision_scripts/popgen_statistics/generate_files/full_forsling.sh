#!/bin/bash
set -e

bash vcf_select_forsling.sh
bash vcf_select_forsling_pi.sh
bash extract_rgs_forsling.sh && \
bash cov_count_forsling_1chr_correct.sh

cd forsling && bash calc_theta_and_pi.sh && cd ldx && bash ldx_it.sh
