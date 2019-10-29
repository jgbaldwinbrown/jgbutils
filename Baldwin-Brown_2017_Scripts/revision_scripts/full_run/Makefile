all: out/fst.txt.done out/out.treeout.done out/npstat_out.txt.done

inter/snpsfile.txt.done: ../snpstable_conversion/make_snpsfile.py data/only-PASS-Q30-SNPs-cov.txt
	python $^ > inter/snpsfile.txt
	touch $@

inter/snpsfile_deg.txt.done: ../snpstable_conversion/get_4fold_deg_snptable.py inter/snpsfile.txt.done data/ data/shrimp_4fold_degs_10-23-15.bed
	python $< inter/snpsfile.txt data/shrimp_4fold_degs_10-23-15.bed > inter/snpsfile_deg.txt
	touch $@

inter/bpout_deg/runbp_deg.done: ../baypass/run_bp_deg.sh inter/snpsfile_deg.txt data/poolsize.txt
	bash $<
	touch $@

inter/bpout/runbp.done: ../baypass/run_bp.sh inter/snpsfile.txt data/poolsize.txt
	bash $<
	touch $@

inter/bpout_omega/runbp_deg.done: ../baypass/run_bp_omega.sh inter/snpsfile.txt data/poolsize.txt inter/bpout_deg/runbp_deg.done
	bash $<
	touch $@

inter/bpout_eco/runbp_eco.done: ../baypass/run_bp_eco.sh inter/snpsfile.txt data/poolsize.txt
	bash $<
	touch $@

inter/bpout_eco_omega/runbp_deg.done: ../baypass/run_bp_eco_omega.sh inter/snpsfile.txt data/poolsize.txt inter/bpout_deg/runbp_deg.done
	bash $<
	touch $@

inter/merged-realigned.mpileup.gz.done: ../npstat/mpileup.sh data/merged-realigned.bam data/ref/shrimp_qmerged.quiver.fasta
	bash $<
	touch $@

out/npstat_out.txt.done: ../npstat/run_npstat.sh inter/merged-realigned.mpileup.gz.done
	bash $<
	touch $@

out/out.treeout.done: ../treemix/run_treemix.sh ../treemix/baypass2treemix.py ../treemix/run_baypass2treemix.py inter/snpsfile.txt.done
	bash $<
	touch $@

out/fst.txt.done: ../poolfst/run_pfs.sh ../poolfst/pfs.R inter/snpsfile.txt data/poolsize.txt
	bash $<
	touch $@
