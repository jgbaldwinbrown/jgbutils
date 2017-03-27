find . -name 'XtX*' | grep -v simulate | xargs average_bayenv_out.py > mean_XtX_out.normalized_transposed_tank_info_11pop.txt
find . -name 'bf*' | grep -v simulate | grep -v thresh | xargs average_bayenv_out.py > mean_bf_environ.normalized_transposed_tank_info_11pop.txt
find . -name 'XtX*' | grep simulate | xargs average_bayenv_out.py > simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt
find . -name 'bf*' | grep simulate | xargs average_bayenv_out.py > simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt

numsnps_xtx=`wc -l mean_XtX_out.normalized_transposed_tank_info_11pop.txt | cut -d ' ' -f 1 | tr -d '\n'`
numsnps_bf=`wc -l mean_bf_environ.normalized_transposed_tank_info_11pop.txt | cut -d ' ' -f 1 | tr -d '\n'`

bayenv_sig_thresh.py -g $numsnps_xtx simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt > xtx_thresh_11pop.txt
bayenv_sig_thresh.py -g $numsnps_bf simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt > bf_thresh_11pop.txt

