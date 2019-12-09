all: out/fst.txt.done out/out.treeout.done out/npstat_out.txt.done inter/bpout_deg/runbp_deg.done inter/bpout/runbp.done inter/bpout_omega/runbp_deg.done inter/bpout_eco/runbp_eco.done inter/bpout_eco_omega/runbp_deg.done out/bcf_samtools.raw.bcf.done

temp: inter/bpout_deg/runbp_deg.done inter/bpout/runbp.done out/bcf_samtools.raw.bcf.done

.PHONY: all tree fst npstat

.DELETE_ON_ERROR:

inter/snpsfile.txt.done: data/old_snpsfiles/snpsfile_11pop_bp.txt
	cp $< inter/snpsfile.txt
	touch $@

inter/snpsfile_deg.txt.done: data/old_snpsfiles/snpsfile_11pop_degs_censv2_bp.txt
	cp $< inter/snpsfile_deg.txt
	touch $@

inter/bpout_deg/runbp_deg.done: ../baypass/run_bp_deg.sh inter/snpsfile_deg.txt.done data/poolsize.txt
	bash $<
	touch $@

inter/bpout/runbp.done: ../baypass/run_bp.sh inter/snpsfile.txt.done data/poolsize.txt
	bash $<
	touch $@

inter/bpout_omega/runbp_deg.done: ../baypass/run_bp_omega.sh inter/snpsfile.txt.done data/poolsize.txt inter/bpout_deg/runbp_deg.done
	bash $<
	touch $@

inter/bpout_eco/runbp_eco.done: ../baypass/run_bp_eco.sh inter/snpsfile.txt.done data/poolsize.txt
	bash $<
	touch $@

inter/bpout_eco_omega/runbp_deg.done: ../baypass/run_bp_eco_omega.sh inter/snpsfile.txt.done data/poolsize.txt inter/bpout_deg/runbp_deg.done
	bash $<
	touch $@

inter/merged-realigned.mpileup.gz.done: ../npstat/mpileup.sh data/merged-realigned-deduped2.bam data/ref/shrimp_qmerged.quiver.fasta
	bash $<
	touch $@

npstat: out/npstat_out.txt.done
out/npstat_out.txt.done: ../npstat/run_npstat.sh inter/merged-realigned.mpileup.gz.done
	bash $<
	touch $@

tree: out/out.treeout.done
out/out.treeout.done: ../treemix/run_treemix.sh ../treemix/baypass2treemix.py ../treemix/run_baypass2treemix.sh inter/snpsfile.txt.done
	bash $<
	touch $@

tree_sam: out/out_sam.treeout.done
out/out_sam.treeout.done: ../treemix/sam/run_treemix.sh ../treemix/baypass2treemix.py inter/snpsfile_sam.txt.done ../treemix/plot.py
	bash $<
	touch $@

tree_sam_small: out/out_sam_small.treeout.done
out/out_sam_small.treeout.done: ../treemix/sam/run_treemix_small.sh ../treemix/baypass2treemix.py inter/snpsfile_sam.txt.done ../treemix/plot.py
	bash $<
	touch $@

tree_hap2: out/out_hap2.treeout.done out/treemix_out_hap2.png.done
out/out_hap2.treeout.done: ../treemix/hap2/run_treemix.sh ../treemix/baypass2treemix.py inter/snpsfile_hap2.txt.done ../treemix/plot.py
	bash $<
	touch $@

out/treemix_out_hap2.png.done: ../treemix/plotpng.py out/out_hap2.treeout.done
	python3 $< out/out_hap2.treeout out/treemix_out_hap2.png
	touch $@

tree_hap200: out/out_hap200.treeout.done
out/out_hap200.treeout.done: ../treemix/hap200/run_treemix.sh ../treemix/baypass2treemix.py inter/snpsfile_hap200.txt.done ../treemix/plot.py
	bash $<
	touch $@

tree_old_correct: out/out_old_correct.treeout.done
out/out_old_correct.treeout.done: ../treemix/old_correct/run_treemix.sh ../treemix/baypass2treemix.py inter/snpsfile_old_correct.txt.done ../treemix/plot.py
	bash $<
	touch $@

fst: out/fst.txt.done
out/fst.txt.done: ../poolfst/run_pfs.sh ../poolfst/pfs.R inter/snpsfile.txt.done data/poolsize.txt
	bash $<
	touch $@

fst_sam: out/fst_sam.txt.done
out/fst_sam.txt.done: ../poolfst/sam/run_pfs.sh ../poolfst/sam/pfs.R inter/snpsfile_sam.txt.done data/poolsize.txt
	bash $<
	touch $@

fst_hap2: out/fst_hap2.txt.done
out/fst_hap2.txt.done: ../poolfst/hap2/run_pfs.sh ../poolfst/hap2/pfs.R inter/snpsfile_hap2.txt.done data/poolsize.txt
	bash $<
	touch $@

fst_hap200: out/fst_hap200.txt.done
out/fst_hap200.txt.done: ../poolfst/hap200/run_pfs.sh ../poolfst/hap200/pfs.R inter/snpsfile_hap200.txt.done data/poolsize.txt
	bash $<
	touch $@

fst_old_correct: out/fst_old_correct.txt.done
out/fst_old_correct.txt.done: ../poolfst/old_correct/run_pfs.sh ../poolfst/old_correct/pfs.R inter/snpsfile_old_correct.txt.done data/poolsize.txt
	bash $<
	touch $@

out/bcf_samtools.raw.bcf.done: ../samtools_snpcall/samcall.sh
	bash $<
	touch $@

inter/merged-realigned.mpileup.splits.done: ../samtools_snpcall/split_mpileup.sh data/merged-realigned-deduped2.bam data/ref/shrimp_qmerged.quiver.fasta
	bash $<
	touch $@

inter/samcalls.splits.done: ../samtools_snpcall/split_samcall.sh inter/merged-realigned.mpileup.splits.done data/ref/shrimp_qmerged.quiver.fasta
	bash $<
	touch $@

inter/samcalls_sync.splits.done: ../samtools_snpcall/split_samcall_sync.sh inter/merged-realigned.mpileup.splits.done inter/samcalls.splits.done data/ref/shrimp_qmerged.quiver.fasta
	bash $<
	touch $@

hmm: out/hmm_out.txt.done
out/hmm_out.txt.done: ../hmm/hid.R inter/bpout/bpout_summary_pi_xtx.out
	Rscript $^ out/hmm_out.txt out/hmm_out.pdf
	touch $@

hmm_test: out/hmm_out_test.txt.done
out/hmm_out_test.txt.done: ../hmm/test/hmm_test.R ../hmm/hmm.R inter/bpout_test/bpout_summary_pi_xtx.out
	bash $<
	touch $@

hmm_test_mini: out/hmm_out_test_mini.txt.done
out/hmm_out_test_mini.txt.done: ../hmm/test/hmm_test_mini.R ../hmm/hmm.R inter/bpout_test/bpout_summary_pi_xtx_mini.out
	bash $<
	touch $@
