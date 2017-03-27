Rscript make_testdat.R
python ../bayenv_sig_thresh.py -g 1000 testdat3.txt > defthresh3.txt
python ../bayenv_sig_thresh.py -g 1000 -w 10 testdat3.txt > defthresh3_10win.txt
trash testdat3.txt
