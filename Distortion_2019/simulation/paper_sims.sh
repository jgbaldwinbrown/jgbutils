#!/bin/bash

set -e

if [ ! -f bias_cov.txt.done ] ; then
	Rscript full_binomdat_sim_chrbias_covsignal.R -r 50 -R 20 -g 2000 -t 1000 -d 0.5 -O bias_cov.txt
	touch bias_cov.txt.done
fi

if [ ! -f out_sim.txt.done ] ; then
	Rscript full_binomdat_sim_unphased.R -r 50 -R 20 -g 2000 -t 1000 -d 0.2
	touch out_sim.txt.done
fi

if [ ! -f bias_cov_clean.txt.gz.done ] ; then
	cat bias_cov.txt | \
	sed 's/"//g' | \
	sed 's/ /	/g' | \
	go run stripcol.go | \
	pigz -p 8 -c \
	> bias_cov_clean.txt.gz
	touch bias_cov_clean.txt.gz.done
fi

if [ ! -f out_sim_clean.txt.gz.done ] ; then
	cat out_sim.txt | \
	sed 's/"//g' | \
	sed 's/ /	/g' | \
	go run stripcol.go | \
	pigz -p 8 -c \
	> out_sim_clean.txt.gz
	touch out_sim_clean.txt.gz.done
fi
