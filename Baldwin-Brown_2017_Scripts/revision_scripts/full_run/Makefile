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

fst: out/fst.txt.done
out/fst.txt.done: ../poolfst/run_pfs.sh ../poolfst/pfs.R inter/snpsfile.txt.done data/poolsize.txt
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
