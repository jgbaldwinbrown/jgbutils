#set shell
SHELL := /bin/bash

#set major targets
all: mean_XtX_out.normalized_transposed_tank_info_11pop.txt mean_bf_environ.normalized_transposed_tank_info_11pop.txt mean_XtX_out.normalized_transposed_tank_info_11pop_newenv.txt mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt xtx_thresh_11pop.txt bf_thresh_11pop.txt manhat_plot_allstats_withlabels_withlines_5avg_multistat_forpaper.tif dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead.txt dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS gene_association/ultimate_gene_name_table_muthits_small.txt gene_association/shrimp_augustus_all_10-12-15_withnames.gff3 gene_association/ultimate_gene_name_table_de_associations.txt gene_association/significant_xtx_snps_associated_with_genes.txt gene_association/significant_xtx_snps_associated_with_genes_no5kb.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt gene_association/xtxsig_genes_no5kb.txt gene_association/xtxsig_genes.txt gene_association/significant_xtx_snps_associated_with_genes_igv.txt bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_igv.txt bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_igv_sigs.txt gene_association/xtxsig_go_hits.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt gene_association/significant_bf_snps_associated_with_genes.txt gene_association/bfsig_genes.txt gene_association/bfsig_go_hits.txt manhat_plotted_bfs.txt manhat_plotted_lfmm.txt lfmm_sim_full_combo.zscore sweed_sim_full_combo.txt lfmm_thresh_11pop.txt sweed_thresh_11pop.txt xtx_thresh_11pop_25win.txt bf_thresh_11pop_25win.txt lfmm_thresh_11pop_100win.txt sweed_thresh_11pop_25win.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt bfs_igv.txt all_lfmm_igvs_done.txt snptable_submean_abs_freqs.txt snptable_submean_freqs.txt snptable_submean_abs_freqs_igv.igv snptable_submean_freqs_igv.igv gene_association/fst_significance_data/fst_mean_sigthresh_fst_nowin.txt gene_association/fst_significance_data/fst_mean_sigthresh_fst.txt manhat_plot_allstats_withlabels_withlines_5avg_sweed_multistat_forpaper.tif qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill.tif qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill.tif qq_plot_allstats_withlabels_5avg_sweed_multistat_forpaper_hill.tif qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt.tif qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt.tif qq_plot_allstats_withlabels_5avg_sweed_multistat_forpaper_hill_alt.tif bf_multiwin/dsbig_fused_xtxonly_final.txt bf_multiwin/dsbig_fused_bf23only_final.txt bf_multiwin/dsbig_fused_bf2only_final.txt gene_association/fst_significance_data/fst_only.txt manhat_plotted_bfs_newenv.txt manhat_plot_allstats_withlabels_withlines_5avg_agnostic_multistat_forpaper.tif manhat_plot_allstats_withlabels_withlines_5avg_env_multistat_forpaper.tif qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt2.tif qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt3.tif qq_plot_allstats_withlabels_5avg_ltervt011_fst_gamma.tif qq_plot_allstats_withlabels_5avg_walvee_fst_gamma.tif qq_plot_allstats_withlabels_5avg_ltervt011_fst_expnorm.tif qq_plot_allstats_withlabels_5avg_walvee_fst_expnorm.tif qq_plot_allstats_withlabels_5avg_walvee_log10_fst_gamma.tif qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_gamma.tif qq_plot_allstats_withlabels_5avg_walvee_log10_fst_expnorm.tif qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_expnorm.tif qq_plot_allstats_withlabels_5avg_walvee_fst_norm.tif qq_plot_allstats_withlabels_5avg_ltervt011_fst_norm.tif qq_plot_allstats_withlabels_5avg_walvee_log10_fst_norm.tif qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_norm.tif qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt4.tif qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt3.tif sigs_xtx_allgenes.txt sigs_xtx_13regions.txt sigs_xtx_13regions_allgenes.txt gene_association/significant_bf_snps_associated_with_genes_partial.txt gene_association/bfsig_genes_newenv_allgenes_elevation.txt gene_association/bfsig_genes_newenv_allgenes.txt gene_association/bfsig_genes_allgenes.txt gene_association/significant_xtx_snps_associated_with_genes_13regions_allgenes_and_nonsig.txt

clean:
	-rm -r mean*
	-rm -r simulated_mean*
	-cp --backup=t xtx_thresh_11pop.txt xtx_thresh_11pop_backup.txt && rm -r xtx_thresh_11pop.txt
	-cp --backup=t bf_thresh_11pop.txt bf_thresh_11pop_backup.txt && rm -r bf_thresh_11pop.txt
	-rm -r combo_all.txt
	-rm bf_multiwin/*.txt
	-rm dsbig*.txt
	-rm gene_association/ultimate*
	-rm gene_association/significant*
	-rm gene_association/mean*

archive:
	tar -czvf all_data.tar.gz --files-from <(find . -type f | grep -E "/mean|/xtx_thresh|/bf_thresh|\.tif$$|/dsbig_fused|/ultimate|/significant" | grep -vE "/old|/trash|/output_copy" | sort)

copy_plots:
	rsync -avP --files-from <(find . -name '*.tif' | grep -vE 'old|output_copy|backup') . /home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/paper_plots/

#generate initial files to use throughout the make process
combo_all.txt:
	bash combine_all.sh
	echo "done" > combo_all.txt
combo_all_newenv_nonsim.txt:
	bash combine_all_newenv_nonsim.sh
	echo "done" > $@
combo_all_newenv_sim.txt:
	bash combine_all_newenv_sim.sh
	echo "done" > $@

#average all bayenv runs together
mean_XtX_out.normalized_transposed_tank_info_11pop.txt:
	find . -name 'XtX*' | grep -v simulate | xargs python average_bayenv_out.py > $@
mean_bf_environ.normalized_transposed_tank_info_11pop.txt:
	find . -name 'bf*' | grep -v simulate | grep -v bf_multiwin | grep -v thresh | xargs python average_bayenv_out.py > $@

mean_XtX_out.normalized_transposed_tank_info_11pop_newenv.txt:
	find . -name 'XtX*' | grep 'newenv_nonsim' | grep -v simulate | xargs python average_bayenv_out.py > $@
mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt:
	find . -name 'bf*' | grep 'newenv_nonsim' | grep -v simulate | grep -v bf_multiwin | grep -v thresh | xargs python average_bayenv_out.py > $@

#average all simulated runs together
simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt: combo_all.txt
	find . -name 'XtX*' | grep simulate | xargs python average_bayenv_out.py > $@
simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt: combo_all.txt
	find . -name 'bf*' | grep simulate | xargs python average_bayenv_out.py > $@
lfmm_sim_full_combo.zscore: merge_all_lfmm_sims.sh
	cd lfmm_sims && find . -name '*zscore*' | grep -v 'split.' | while read i ; do mv $$i $$(echo $$i | sed 's/split[0-9][0-9]/split/g'); done
	bash $<	
sweed_sim_full_combo.txt: merge_all_sweed_sims.sh
	bash $<

simulated_mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt: combo_all_newenv_sim.txt
	find . -name 'bf*' | grep newenv_sim | xargs python average_bayenv_out.py > $@

#convert simulated data to RDS
simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS: simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt
	table_to_rds.R $^ $@
simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS: simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt
	table_to_rds.R $^ $@

#calculate significance thresholds for manhattan plotting
xtx_thresh_11pop.txt: simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt
	numsnps_xtx=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -g $$numsnps_xtx simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt > $@
bf_thresh_11pop.txt: simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -g $$numsnps_bf simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt > $@
lfmm_thresh_11pop.txt: lfmm_sim_full_combo.zscore
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -i -g $$numsnps_bf $< > $@
sweed_thresh_11pop.txt: sweed_sim_full_combo.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -g $$numsnps_bf $< > $@
gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
	cd gene_association/fst_significance_data/ && bash get_fst_significance_nowin.sh

bf_thresh_11pop_newenv.txt: simulated_mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -g $$numsnps_bf simulated_mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt > $@

#calculate windowed significance thresholds for manhattan plotting:
xtx_thresh_11pop_25win.txt: simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt
	numsnps_xtx=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -w 25 -g $$numsnps_xtx simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.txt > $@
bf_thresh_11pop_25win.txt: simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -w 25 -g $$numsnps_bf simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.txt > $@
lfmm_thresh_11pop_100win.txt: lfmm_sim_full_combo.zscore
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -i -w 100 -g $$numsnps_bf $< > $@
sweed_thresh_11pop_25win.txt: sweed_sim_full_combo.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -w 25 -g $$numsnps_bf $< > $@
gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
	cd gene_association/fst_significance_data/ && bash get_fst_significance.sh

bf_thresh_11pop_25win_newenv.txt: simulated_mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt
	numsnps_bf=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -w 25 -g $$numsnps_bf simulated_mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt > $@


#calculate fst significance threshold (not just pval thresh, but fst thresh):
gene_association/fst_significance_data/fst_mean_sigthresh_fst_nowin.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
	cd gene_association/fst_significance_data/ && bash get_fst_significance_notp_nowin.sh
gene_association/fst_significance_data/fst_mean_sigthresh_fst.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
	cd gene_association/fst_significance_data/ && bash get_fst_significance_notp.sh


#do all plotting
#qq_plot_agnostic_stats_for_paper_withlabels.R  qq_plot_all_stats_for_paper_withlabels.R  qq_plot_env_stats_for_paper_withlabels.R  qq_plot_sweed.R
#qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_agnostic_stats_for_paper_withlabels.R
#	Rscript qq_plot_agnostic_stats_for_paper_withlabels.R
#qq_plot_allstats_withlabels_5avg_env_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_env_stats_for_paper_withlabels.R
#	Rscript qq_plot_env_stats_for_paper_withlabels.R
#qq_plot_allstats_withlabels_5avg_sweed_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_sweed.R
#	Rscript qq_plot_sweed.R

#qq_plot_agnostic_stats_for_paper_withlabels.R  qq_plot_all_stats_for_paper_withlabels.R  qq_plot_env_stats_for_paper_withlabels.R  qq_plot_sweed.R
qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_agnostic_stats_for_paper_withlabels_hill.R
	Rscript qq_plot_agnostic_stats_for_paper_withlabels_hill.R
qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_env_stats_for_paper_withlabels_hill.R
	Rscript qq_plot_env_stats_for_paper_withlabels_hill.R
qq_plot_allstats_withlabels_5avg_sweed_multistat_forpaper_hill.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_sweed_hill.R
	Rscript qq_plot_sweed_hill.R

qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_agnostic_stats_for_paper_withlabels_hill_alt.R
	Rscript qq_plot_agnostic_stats_for_paper_withlabels_hill_alt.R
qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_env_stats_for_paper_withlabels_hill_alt.R
	Rscript qq_plot_env_stats_for_paper_withlabels_hill_alt.R
qq_plot_allstats_withlabels_5avg_sweed_multistat_forpaper_hill_alt.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_sweed_hill_alt.R
	Rscript qq_plot_sweed_hill_alt.R

qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt2.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_agnostic_stats_for_paper_withlabels_hill_alt2.R
	Rscript qq_plot_agnostic_stats_for_paper_withlabels_hill_alt2.R
qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt3.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_env_stats_for_paper_withlabels_hill_alt3.R
	Rscript qq_plot_env_stats_for_paper_withlabels_hill_alt3.R

qq_plot_allstats_withlabels_5avg_agnostic_multistat_forpaper_hill_alt3.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_agnostic_stats_for_paper_withlabels_hill_alt3.R
	Rscript qq_plot_agnostic_stats_for_paper_withlabels_hill_alt3.R
qq_plot_allstats_withlabels_5avg_env_multistat_forpaper_hill_alt4.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_env_stats_for_paper_withlabels_hill_alt4.R
	Rscript qq_plot_env_stats_for_paper_withlabels_hill_alt4.R


qq_plot_allstats_withlabels_5avg_walvee_fst_gamma.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_gamma.R
	Rscript qq_plot_walvee_gamma.R
qq_plot_allstats_withlabels_5avg_ltervt011_fst_gamma.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_gamma.R
	Rscript qq_plot_ltervt011_gamma.R
qq_plot_allstats_withlabels_5avg_walvee_fst_expnorm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_expnorm.R
	Rscript qq_plot_walvee_expnorm.R
qq_plot_allstats_withlabels_5avg_ltervt011_fst_expnorm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_expnorm.R
	Rscript qq_plot_ltervt011_expnorm.R

qq_plot_allstats_withlabels_5avg_walvee_log10_fst_gamma.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_log10_gamma.R
	Rscript qq_plot_walvee_log10_gamma.R
qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_gamma.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_log10_gamma.R
	Rscript qq_plot_ltervt011_log10_gamma.R
qq_plot_allstats_withlabels_5avg_walvee_log10_fst_expnorm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_log10_expnorm.R
	Rscript qq_plot_walvee_log10_expnorm.R
qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_expnorm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_log10_expnorm.R
	Rscript qq_plot_ltervt011_log10_expnorm.R

qq_plot_allstats_withlabels_5avg_walvee_fst_norm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_norm.R
	Rscript qq_plot_walvee_norm.R
qq_plot_allstats_withlabels_5avg_ltervt011_fst_norm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_norm.R
	Rscript qq_plot_ltervt011_norm.R
qq_plot_allstats_withlabels_5avg_walvee_log10_fst_norm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_walvee_log10_norm.R
	Rscript qq_plot_walvee_log10_norm.R
qq_plot_allstats_withlabels_5avg_ltervt011_log10_fst_norm.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS qq_plot_ltervt011_log10_norm.R
	Rscript qq_plot_ltervt011_log10_norm.R


manhat_plot_allstats_withlabels_withlines_5avg_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS xtx_thresh_11pop.txt bf_thresh_11pop.txt manhat_plot_all_stats_for_paper_withlabels_withlines.R lfmm_thresh_11pop.txt sweed_thresh_11pop.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt xtx_thresh_11pop_25win.txt bf_thresh_11pop_25win.txt lfmm_thresh_11pop_100win.txt sweed_thresh_11pop_25win.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt
	Rscript manhat_plot_all_stats_for_paper_withlabels_withlines.R

manhat_plot_allstats_withlabels_withlines_5avg_agnostic_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS xtx_thresh_11pop.txt bf_thresh_11pop.txt manhat_plot_all_stats_for_paper_withlabels_withlines.R lfmm_thresh_11pop.txt sweed_thresh_11pop.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt xtx_thresh_11pop_25win.txt bf_thresh_11pop_25win.txt lfmm_thresh_11pop_100win.txt sweed_thresh_11pop_25win.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt
	Rscript manhat_plot_all_stats_for_paper_withlabels_withlines_agnostic.R
manhat_plot_allstats_withlabels_withlines_5avg_env_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS xtx_thresh_11pop.txt bf_thresh_11pop.txt manhat_plot_all_stats_for_paper_withlabels_withlines.R lfmm_thresh_11pop.txt sweed_thresh_11pop.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt xtx_thresh_11pop_25win.txt bf_thresh_11pop_25win.txt lfmm_thresh_11pop_100win.txt sweed_thresh_11pop_25win.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt
	Rscript manhat_plot_all_stats_for_paper_withlabels_withlines_env.R


manhat_plot_allstats_withlabels_withlines_5avg_sweed_multistat_forpaper.tif: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS xtx_thresh_11pop.txt bf_thresh_11pop.txt manhat_plot_swee_forpaper.R lfmm_thresh_11pop.txt sweed_thresh_11pop.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals_nowin.txt xtx_thresh_11pop_25win.txt bf_thresh_11pop_25win.txt lfmm_thresh_11pop_100win.txt sweed_thresh_11pop_25win.txt gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums_pvals.txt
	Rscript manhat_plot_swee_forpaper.R

manhat_plotted_bfs.txt: manhat_plot_all_bfs.R dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS bf_thresh_11pop.txt bf_thresh_11pop_25win.txt
	python -c "print '\n'.join(map(str,range(2,72,3)))" | xargs -i -P3 Rscript $< "{}"
	touch $@

manhat_plotted_bfs_newenv.txt: manhat_plot_all_bfs_newenv.R dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.RDS bf_thresh_11pop_newenv.txt bf_thresh_11pop_25win_newenv.txt
	python -c "print '\n'.join(map(str,range(2,36,3)))" | xargs -i -P3 Rscript $< "{}"
	touch $@
manhat_plotted_bfs_newenv_last.txt: manhat_plot_last_bf_newenv.R dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.RDS bf_thresh_11pop_newenv.txt bf_thresh_11pop_25win_newenv.txt
	python -c "print '\n'.join(map(str,range(35,36,3)))" | xargs -i -P3 Rscript $< "{}"
	touch $@


#plot all LFMM manhats:
lfmm_all_rds.txt:
	python -c "print '\n'.join(map(str,range(1,25,1)))" | xargs -i -P4 table_to_rds.R lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s"{}".9.zscoreavg.withchroms.withhead.sorted.multiwin_1000 lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s{}.9.zscoreavg.withchroms.withhead.sorted.multiwin_1000.RDS
	touch $@

manhat_plotted_lfmm.txt: manhat_plot_all_lfmms.R lfmm_all_rds.txt lfmm_thresh_11pop.txt lfmm_thresh_11pop_100win.txt labels_combined2.txt
	python -c "print '\n'.join(map(str,range(1,25,1)))" | xargs -i -P4 Rscript $< "{}"
	touch $@

#generate final data table to use for plotting
dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted.txt: mean_XtX_out.normalized_transposed_tank_info_11pop.txt mean_bf_environ.normalized_transposed_tank_info_11pop.txt only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt shrimp_qmerged.quiver.fasta.chromcounts
	add_chrom_to_bayenv_out_v8.py $^ > $(addsuffix .withNA,$@)
	grep -v "NA" $(addsuffix .withNA,$@) > $(addsuffix .unsorted,$@)
	sort_finalout_2col.py $(addsuffix .unsorted,$@) > $@
	rm $(addsuffix .withNA,$@)
	rm $(addsuffix .unsorted,$@)

dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead.txt: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted.txt only-PASS-Q30-SNPS-cov_v2_8sigfig_ds_7_11_v1_fused_cens_10_200_3_goods.txt 
	censor_master.py -c 0 $^ > $(addsuffix .nohead,$@)
	./add_header.py $(addsuffix .nohead,$@) > $@
dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq.txt: uniq_col1.py dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead.txt
	python $^ > $@

dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_newenv.txt: mean_XtX_out.normalized_transposed_tank_info_11pop_newenv.txt mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt shrimp_qmerged.quiver.fasta.chromcounts
	add_chrom_to_bayenv_out_v8.py $^ > $(addsuffix .withNA,$@)
	grep -v "NA" $(addsuffix .withNA,$@) > $(addsuffix .unsorted,$@)
	sort_finalout_2col.py $(addsuffix .unsorted,$@) > $@
	rm $(addsuffix .withNA,$@)
	rm $(addsuffix .unsorted,$@)

dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_newenv.txt: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_newenv.txt only-PASS-Q30-SNPS-cov_v2_8sigfig_ds_7_11_v1_fused_cens_10_200_3_goods.txt 
	censor_master.py -c 0 $^ > $(addsuffix .nohead,$@)
	./add_header.py $(addsuffix .nohead,$@) > $@
dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_newenv.txt: uniq_col1.py dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_newenv.txt
	python $^ > $@


#generate multiple sliding window averages
bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin.txt: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq.txt
	mkdir -p bf_multiwin
	bash make_all_multiwins.sh
bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin.txt
	mkdir -p bf_multiwin
	bash make_xtx_multiwins.sh

bf_multiwin_newenv/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_newenv.txt: dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_newenv.txt
	mkdir -p bf_multiwin_newenv
	bash make_all_multiwins_newenv.sh
bf_multiwin_newenv/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.txt: bf_multiwin_newenv/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_newenv.txt
	mkdir -p bf_multiwin_newenv
	bash make_xtx_multiwins_newenv.sh

#convert final table into RDS format
dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt
	table_to_rds.R $^ $@
dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.RDS: bf_multiwin_newenv/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.txt
	table_to_rds.R $^ $@


gene_association/ultimate_gene_name_table_v4.txt: gene_association/build_gene_name_table_v4.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot
	python $< > $@

gene_association/ultimate_gene_name_table_de_associations.txt: gene_association/associate_de_genes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/clam_shrimp_deseq_hiselec_genes_bigOutFilt_allselec.txt gene_association/clam_shrimp_deseq_hiselec_genes_bigOutFilt.txt
	python $< > $@

gene_association/ultimate_gene_name_table_muthits.txt: gene_association/get_only_ones_with_muthits.py gene_association/ultimate_gene_name_table_v4.txt
	python $^ > $@

gene_association/shrimp_augustus_all_10-12-15_withnames.gff3: gene_association/add_dmel_to_shrimp_gff_file.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz
	python $< > $@

gene_association/ultimate_gene_name_table_muthits_small.txt: gene_association/ultimate_gene_name_table_muthits.txt
	keep_arbitrary_cols.py $^ 0,1,2,6,7,8 > $@

gene_association/significant_xtx_snps_associated_with_genes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt
	python $< > $@

gene_association/significant_xtx_snps_associated_with_genes_no5kb.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig_no5kb.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt
	python $< > $@

gene_association/significant_xtx_snps_associated_with_genes_allgenes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig_allgenes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt
	python $< > $@

gene_association/significant_xtx_snps_associated_with_genes_13regions.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig_13regions.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt
	python $< > $@

gene_association/significant_xtx_snps_associated_with_genes_13regions_allgenes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig_13regions_allgenes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt sigs_xtx_13regions.txt
	python $< > $@

gene_association/significant_xtx_snps_associated_with_genes_13regions_allgenes_and_nonsig.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_xtxsig_13regions_allgenes_and_nonsig.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt sigs_xtx_13regions.txt
	python $< > $@

sigs_xtx_no5kb.txt: gene_association/significant_xtx_snps_associated_with_genes_no5kb.txt
	cat $^ | cut -d '        ' -f 6 | tail -n +2 | tr ';' '\n' | sort | uniq > $@

sigs_xtx.txt: gene_association/significant_xtx_snps_associated_with_genes.txt
	cat $^ | cut -d '        ' -f 6 | tail -n +2 | tr ';' '\n' | sort | uniq > $@

sigs_xtx_allgenes.txt: gene_association/significant_xtx_snps_associated_with_genes_allgenes.txt
	cat $^ | cut -d '        ' -f 6 | tail -n +2 | tr ';' '\n' | sort | uniq > $@

sigs_xtx_13regions.txt: gene_association/significant_xtx_snps_associated_with_genes_13regions.txt
	cat $^ | cut -d '        ' -f 6 | tail -n +2 | tr ';' '\n' | sort | uniq > $@

sigs_xtx_13regions_allgenes.txt: gene_association/significant_xtx_snps_associated_with_genes_13regions_allgenes.txt
	cat $^ | cut -d '        ' -f 6 | tail -n +2 | tr ';' '\n' | sort | uniq > $@

gene_association/mean_XtX_out.normalized_transposed_tank_info_11pop_xtxsigfilter.txt: mean_XtX_out.normalized_transposed_tank_info_11pop.txt xtx_thresh_11pop.txt
	sig_thresh=`cat xtx_thresh_11pop.txt | tr -d '\n'`; cat "$<" | filter_by_column2.py 1 ">=$${sig_thresh}" > $@

gene_association/xtxsig_genes.txt: gene_association/significant_xtx_snps_associated_with_genes.txt
	cat $^ | cut -d '	' -f 6 | tr ';' '\n' > $@

gene_association/xtxsig_genes_no5kb.txt: gene_association/significant_xtx_snps_associated_with_genes_no5kb.txt
	cat $^ | cut -d '	' -f 6 | tr ';' '\n' > $@

gene_association/significant_xtx_snps_associated_with_genes_igv.txt: gene_association/significant_xtx_snps_associated_with_genes.txt convert_to_igv.py
	keep_arbitrary_cols.py $< 1,2,0,3 > $@.temp1
	head -1 $@.temp1 > $@.temp2 ;  sort $@.temp1 -k 1,1 -k 2,2n | grep -v "pos" >> $@.temp2
	python convert_to_igv.py $@.temp2 > $@
	rm $@.temp*

bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_igv.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt convert_to_igv.py chrom_namer.py headers_numbered2.txt
	keep_named_cols.py $< chromnum,chrompos,genpos,xtx,xtx_win3,xtx_win5,xtx_win9,xtx_win15,xtx_win25 | python convert_to_igv.py > $@.temp2
	python chrom_namer.py $@.temp2 0 headers_numbered2.txt True > $@
	rm $@.temp*

bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_igv_sigs.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_igv.txt xtx_thresh_11pop.txt
	head -1 $< | tr -d '\n' > $@
	echo "	filter_value" >> $@
	sig_thresh=`cat xtx_thresh_11pop.txt | tr -d '\n'`; cat "$<" | filter_by_column2.py --header 4 ">=$${sig_thresh}" | grep "Passed" >> $@

sweed_sim_fullout.txt: convert_sweed_out.py
	rm $@
	find . -name 'SweeD_Report*' | grep sweed_sim | while read line ; do cat $$line | $< >> $@ ; done

sweed_thresh_10pop.txt: sweed_sim_fullout.txt
        numsnps_sweed=`wc -l $^ | cut -d ' ' -f 1 | tr -d '\n'`; bayenv_sig_thresh.py -g $$numsnps_sweed $^ > $@

gene_association/xtxsig_go_hits.txt: GOrilla.pl gene_association/xtxsig_genes.txt gene_association/de_ranked_genes.txt
	perl $< --organism DROSOPHILA_MELANOGASTER --runmode hg --name jbaldwin --email jbaldwi1@uci.edu --targets gene_association/xtxsig_genes.txt --background gene_association/de_ranked_genes.txt > $@

#####bayes factor go significance:
bf_col_ind.txt: make_column_indices_bf.py
	python $< > $@

gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt: mean_bf_environ.normalized_transposed_tank_info_11pop.txt bf_col_ind.txt bf_thresh_11pop.txt
	for i in {1..24} ; do col=`head -n $${i} bf_col_ind.txt | tail -n 1 | tr -d '\n'` ; thresh_ind=`echo "$$col - 1" | bc` ; sig_thresh=`cat bf_thresh_11pop.txt | tr -d '\n' | tr '	' '\n' | head -n $$thresh_ind | tail -n 1`; cat "$<" | cut -d '	' -f 1,$${col} | filter_by_column2.py 1 ">=$${sig_thresh}" > $(@).$${i} ; done
	touch $@

gene_association/significant_bf_snps_associated_with_genes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_bfsig.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt
	for i in {1..24} ; do python $< $${i} > $(@).$${i} ; done
	touch $@

gene_association/bfsig_genes.txt: gene_association/significant_bf_snps_associated_with_genes.txt
	for i in {1..24} ; do cat $<.$${i} | cut -d '	' -f 6 | tr ';' '\n' > $(@).$${i} ; done
	touch $@

gene_association/bfsig_go_hits.txt: GOrilla.pl gene_association/bfsig_genes.txt gene_association/de_ranked_genes.txt
	-for i in {1..24} ; do perl $< --organism DROSOPHILA_MELANOGASTER --runmode hg --name jbaldwin --email jbaldwi1@uci.edu --targets gene_association/bfsig_genes.txt.$${i} --background gene_association/de_ranked_genes.txt > $(@).$${i} ; done
	touch $@

gene_association/significant_bf_snps_associated_with_genes_allgenes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_bfsig_allgenes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt
	for i in {1..24} ; do python $< $${i} > $(@).$${i} ; done
	touch $@

gene_association/bfsig_genes_allgenes.txt: gene_association/significant_bf_snps_associated_with_genes_allgenes.txt
	for i in {1..24} ; do cat $<.$${i} | cut -d '	' -f 6 | tr ';' '\n' > $(@).$${i} ; done
	touch $@

gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter_newenv.txt: mean_bf_environ.normalized_transposed_tank_info_11pop_newenv.txt bf_col_ind.txt bf_thresh_11pop.txt
	for i in {1..12} ; do col=`head -n $${i} bf_col_ind.txt | tail -n 1 | tr -d '\n'` ; thresh_ind=`echo "$$col - 1" | bc` ; sig_thresh=`cat bf_thresh_11pop.txt | tr -d '\n' | tr '	' '\n' | head -n $$thresh_ind | tail -n 1`; cat "$<" | cut -d '	' -f 1,$${col} | filter_by_column2.py 1 ">=$${sig_thresh}" > $(@).$${i} ; done
	touch $@

gene_association/significant_bf_snps_associated_with_genes_newenv_allgenes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_bfsig_newenv_allgenes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter_newenv.txt
	for i in {2..12} ; do python $< $${i} > $(@).$${i} ; done
	touch $@

gene_association/bfsig_genes_newenv_allgenes.txt: gene_association/significant_bf_snps_associated_with_genes_newenv_allgenes.txt
	for i in {2..12} ; do cat $<.$${i} | cut -d '	' -f 6 | tr ';' '\n' > $(@).$${i} ; done
	touch $@

gene_association/significant_bf_snps_associated_with_genes_newenv_allgenes_elevation.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_bfsig_newenv_allgenes.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter_newenv.txt
	for i in 1 ; do python $< $${i} > $(@).$${i} ; done
	touch $@

gene_association/bfsig_genes_newenv_allgenes_elevation.txt: gene_association/significant_bf_snps_associated_with_genes_newenv_allgenes_elevation.txt
	for i in 1 ; do cat $<.$${i} | cut -d '	' -f 6 | tr ';' '\n' > $(@).$${i} ; done
	touch $@

gene_association/significant_bf_snps_associated_with_genes_partial.txt: gene_association/significant_bf_snps_associated_with_genes_allgenes.txt
	cat $(<).3 > $@
	for i in 4 11 14 15 18 ; do cat $(<).$${i} >> $@ ; done


#####LFMM go significance:
#lfmm_col_ind_100.txt: make_column_indices_lfmm.py
#	python $< > $@
#
#gene_association/lfmm_all_sigfilter.txt: lfmm_col_ind_100.txt lfmm_thresh_11pop_100win.txt
#	sig_thresh=`cat lfmm_thresh_11pop_100win.txt | tr -d '\n'`; for i in {1..24} ; do col=`head -n $${i} bf_col_ind.txt | tail -n 1 | tr -d '\n'` ; cat "$<" | cut -d '	' -f 1,$${col} | filter_by_column2.py 1 ">=$${sig_thresh}" > $(@).$${i} ; done
#	touch $@
#
#gene_association/significant_lfmm_snps_associated_with_genes.txt: gene_association/add_dmel_to_shrimp_gff_file_plus_bfsig.py gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz gene_association/go_data/gene_association.fb.gz gene_association/other/gene_summaries.tsv.gz gene_association/shrimp_augustus_prot_queried_on_dmel_prot gene_association/dmel_prot_queried_on_shrimp_augustus_prot gene_association/shrimp_augustus_all_10-12-15.gff3.gz gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt
#	for i in {1..24} ; do python $< $${i} > $(@).$${i} ; done
#	touch $@
#
#gene_association/bfsig_genes.txt: gene_association/significant_bf_snps_associated_with_genes.txt
#	for i in {1..24} ; do cat $<.$${i} | cut -d '	' -f 6 | tr ';' '\n' > $(@).$${i} ; done
#	touch $@
#
#gene_association/bfsig_go_hits.txt: GOrilla.pl gene_association/bfsig_genes.txt gene_association/de_ranked_genes.txt
#	-for i in {1..24} ; do perl $< --organism DROSOPHILA_MELANOGASTER --runmode hg --name jbaldwin --email jbaldwi1@uci.edu --targets gene_association/bfsig_genes.txt.$${i} --background gene_association/de_ranked_genes.txt > $(@).$${i} ; done
#	touch $@



#####SweeD go significance:
#gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt: mean_bf_environ.normalized_transposed_tank_info_11pop.txt bf_col_ind.txt bf_thresh_11pop.txt
#	sig_thresh=`cat xtx_thresh_11pop.txt | tr -d '\n'`; for i in {1..24} ; do col=`head -n $${i} bf_col_ind.txt | tail -n 1 | tr -d '\n'` ; cat "$<" | cut -d '	' -f 1,$${col} | filter_by_column2.py 1 ">=$${sig_thresh}" > $(@).$${i} ; done
#	touch $@

######generate igv tracks:
#BF:
bfs_igv.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt convert_to_igv.py chrom_namer.py headers_numbered2.txt
	keep_named_cols.py $< chromnum,chrompos,genpos,`python get_all_bf_headers_for_igv.py` | python convert_to_igv.py > $@.temp2
	python chrom_namer.py $@.temp2 0 headers_numbered2.txt True > $@
	rm $@.temp*

#LFMM:
#lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s1.9.zscoreavg.withchroms.withhead.sorted.multiwin_1000
#"CHROM" "POS" "z.score" "adjusted.p.values" "sort_variable" "index_variable"    lfmm_zavg_win1  lfmm_pcombo_win1        lfmm_zavg_win3  lfmm_pcombo_win3        lfmm_zavg_win5  lfmm_pcombo_win5        lfmm_zavg_win9  lfmm_pcombo_win9        lfmm_zavg_win15 lfmm_pcombo_win15       lfmm_zavg_win25 lfmm_pcombo_win25       lfmm_zavg_win50 lfmm_pcombo_win50       lfmm_zavg_win100        lfmm_pcombo_win100      lfmm_zavg_win500        lfmm_pcombo_win500      lfmm_zavg_win1000       lfmm_pcombo_win1000
#python -c "print '\n'.join(map(str,range(1,25,1)))" | xargs -i -P4 Rscript $< "{}"
all_lfmm_igvs_done.txt: convert_to_igv.py chrom_namer.py headers_numbered2.txt
	for i in {1..24} ; do keep_named_cols.py lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s$${i}.9.zscoreavg.withchroms.withhead.sorted.multiwin_1000 \"sort_variable\",\"POS\",\"index_variable\",\"adjusted.p.values\",lfmm_pcombo_win100 | python convert_to_igv.py > lfmm$${i}.temp2 ; done
	for i in {1..24} ; do python chrom_namer.py lfmm$${i}.temp2 0 headers_numbered2.txt False > lfmm_multiwin/lfmm_igv$${i}.txt ; done
	rm lfmm*.temp2
	python -c "print '\n'.join(map(str,range(1,25,1)))" | xargs -i -P4 python change_lfmm_igv_header.py lfmm_multiwin/lfmm_igv"{}".txt "{}"
	rm lfmm_multiwin/lfmm_igv*.txt
	python -c "print '\n'.join(map(str,range(1,25,1)))" | xargs -i -P4 python nlogcols.py -s 0 -c 4,5 -b 10 -n -o lfmm_multiwin/lfmm_igv"{}".igv lfmm_multiwin/lfmm_igv"{}".txtrehead
	touch all_lfmm_igvs_done.txt

#gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
snptable_submean_abs_freqs.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt normalizecols.py
	python normalizecols.py -m -a -c 5,7,9,11,13,15,17,19,21,23,25 -s 0 $< > $@

snptable_submean_freqs.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt normalizecols.py
	python normalizecols.py -m -c 5,7,9,11,13,15,17,19,21,23,25 -s 0 $< > $@

snptable_submean_abs_freqs_igv.igv: snptable_submean_abs_freqs.txt convert_to_igv.py
	keep_named_cols.py $< chromnum,POS,snpname,freq_JBB_hb701_Lcombo,freq_JBB_hb702_Lcombo,freq_JBB_hb703_Lcombo,freq_JBB_hb704_Lcombo,freq_JBB_hb705_Lcombo,freq_JBB_hb706_Lcombo,freq_JBB_hb707_Lcombo,freq_JBB_hb708_Lcombo,freq_JBB_hb709_Lcombo,freq_JBB_hb710_Lcombo,freq_JBB_hb711_Lcombo | python convert_to_igv.py >$@.temp2
	python chrom_namer.py $@.temp2 0 headers_numbered2.txt False > $@
	rm $@.temp*

snptable_submean_freqs_igv.igv: snptable_submean_freqs.txt convert_to_igv.py
	keep_named_cols.py $< chromnum,POS,snpname,freq_JBB_hb701_Lcombo,freq_JBB_hb702_Lcombo,freq_JBB_hb703_Lcombo,freq_JBB_hb704_Lcombo,freq_JBB_hb705_Lcombo,freq_JBB_hb706_Lcombo,freq_JBB_hb707_Lcombo,freq_JBB_hb708_Lcombo,freq_JBB_hb709_Lcombo,freq_JBB_hb710_Lcombo,freq_JBB_hb711_Lcombo | python convert_to_igv.py >$@.temp2
	python chrom_namer.py $@.temp2 0 headers_numbered2.txt False > $@
	rm $@.temp*

bf_multiwin/dsbig_fused_xtxonly_final.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt
	keep_named_cols.py ./bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt index,genpos,chrompos,chromnum,chromlen,xtx,xtx_win25 > bf_multiwin/dsbig_fused_xtxonly_final.txt
bf_multiwin/dsbig_fused_bf23only_final.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt
	keep_named_cols.py ./bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt index,genpos,chrompos,chromnum,chromlen,bf23,bf23_win25 > bf_multiwin/dsbig_fused_bf23only_final.txt
bf_multiwin/dsbig_fused_bf2only_final.txt: bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt
	keep_named_cols.py ./bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt index,genpos,chrompos,chromnum,chromlen,bf2,bf2_win25 > bf_multiwin/dsbig_fused_bf2only_final.txt

gene_association/fst_significance_data/fst_only.txt: gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt
	keep_named_cols.py gene_association/fst_significance_data/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.txt Nmiss,CHROM,POS,REF,ALT,fst_mean,fst_mean_win25,snpname,chromnum > $@
