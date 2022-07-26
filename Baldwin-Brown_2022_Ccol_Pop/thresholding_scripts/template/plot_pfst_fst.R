#!/usr/bin/env Rscript

source("plot_pretty_multiple_helpers.R")

main <- function() {
	args = commandArgs(trailingOnly=TRUE)
	pfst_path = args[1]
	fst_path = args[2]
	out_path = args[3]
	pfst = read_combined_pvals_precomputed(pfst_path)
	fst = read_bed(fst_path, FALSE)

	pfst_hithresh = calc_thresh(pfst, "VAL", .9999, TRUE)
	pfst_lowthresh = -log10(0.05)

	pfst$pass = pass_thresh(pfst, "VAL", pfst_hithresh)
	pfst$color = threshcolor(pfst, "CHR", "pass")

	pfst_threshes = data.frame(THRESH=c(pfst_hithresh, pfst_lowthresh))

	fst$color = nothreshcolor(fst, "CHR")

	joinlist = join(list(pfst, fst), list(pfst_threshes), c("pfst", "fst"), "pfst")
	data = joinlist[[1]]
	thresholds = joinlist[[2]]

	plot(data, VAL, out_path, 20, 8, 300, thresholds, calc_chrom_labels(pfst))
}

main()
