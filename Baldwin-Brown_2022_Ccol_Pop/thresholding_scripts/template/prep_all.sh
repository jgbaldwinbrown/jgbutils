#!/bin/bash
set -e

#BIGFILEPATH=/media/jgbaldwinbrown/3564-3063/jgbaldwinbrown/Documents/work_stuff/louse/poolfstat/from_laptop/vcftools_reruns
BIGFILEPATH=/media/jgbaldwinbrown/jim_work1/jgbaldwinbrown/Documents/work_stuff/louse/poolfstat/from_laptop/vcftools_reruns

CWD=`pwd`
FSTPATH="${CWD}/all_bigfile_fsts.txt"
PFSTPATH="${CWD}/all_bigfile_pfsts.txt"

cp window_fisher_bp.py "${BIGFILEPATH}"
cp bedify.sh "${BIGFILEPATH}"
cp fdr.py "${BIGFILEPATH}"
cp fdr_it.py "${BIGFILEPATH}"
cp plfmt.py "${BIGFILEPATH}"
cp plot_pretty_hlines_bp.R "${BIGFILEPATH}"

cd "${BIGFILEPATH}" && (
	bash all_winplot_multipheno.sh

	find . -name '*pfst.txt' | \
	grep -v 'Makefile' | \
	sed 's/\.txt$//' | \
	./make_all_plots > Makefile_prep_pfst
	make -j 8 -k -f Makefile_prep_pfst > make_out_Makefile_prep_pfst.txt 2>&1

	find $PWD -name '*\.fst_win.txt' > "${FSTPATH}"
	find $PWD -name '*pfst_win_fdr.bed' > "${PFSTPATH}"
)
