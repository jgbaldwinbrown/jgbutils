#!/usr/bin/env Rscript

library(dplyr)
library(data.table)
library(magrittr)
library(ggplot2)
library(facetscales)

read_combined_pvals_precomputed <- function(inpath) {
	giant = as.data.frame(fread(inpath), header=TRUE)
	colnames(giant) = c("chrom", "BP1", "BP", "PFST", "CHISQ", "WINDOW_P", "THRESH", "WINDOW_FDR_P", "WINDOW_FDR_NLOGP", "BONF_THRESH", "CHR", "cumsum.tmp")
	giant$VAL = -log10(giant$WINDOW_FDR_P)
	return(giant)
}

read_combined_pvals <- function(inpath) {
	giant = as.data.frame(fread(inpath), header=TRUE)
	colnames(giant) = c("chrom", "BP1", "BP", "PFST", "CHISQ", "WINDOW_P", "CHR", "cumsum.tmp")
	giant$VAL = -log10(giant$WINDOW_P)
	return(giant)
}

# FST win is in bed format
read_bed <- function(inpath, nlog) {
	giant = as.data.frame(fread(inpath), header=FALSE)
	colnames(giant) = c("chrom", "BP1", "BP", "VAL", "CHR", "cumsum.tmp")
	if (nlog) {
		giant$VAL = -log10(giant$VAL)
	}
	return(giant)
}

read_fst <- function(inpath) {
	giant = as.data.frame(fread(inpath), header=TRUE)
	colnames(giant) = c("chrom", "BP", "FST", "CHR", "cumsum.tmp")
	giant$VAL = giant$FST
	return(giant)
}

read_selec <- function(inpath) {
	giant = as.data.frame(fread(inpath), header=TRUE)
	colnames(giant) = c("chrom", "BP", "S", "S_P", "CHR", "cumsum.tmp")
	giant$VAL = giant$S
	return(giant)
}

calc_chrom_labels <- function(giant) {
	medians <- giant %>% dplyr::group_by(CHR) %>% dplyr::summarise(median.x = median(cumsum.tmp))
}

calc_thresh <- function(data, colname, thresh, na.rm) {
	# usually use .9999 as threshold
	return(quantile(data[,colname], thresh, na.rm=na.rm))
}

pass_thresh <- function(data, colname, thresh) {
	data[,colname] > thresh
}

threshcolor <- function(data, chrcol, passcol) {
	out = factor(((data[,chrcol] %% 2) * (1-data[,passcol])) + (3 * data[,passcol]))
	return(out)
	#return(factor(((data[,chrcol] %% 2) * (1-data[,passcol])) + (3 * data[,passcol])))
}

nothreshcolor <- function(data, chrcol) {
	return(factor(data[,chrcol] %% 2))
}

join <- function(datas, thresholds, names, threshold_names) {
	for (i in 1:length(names)) {
		datas[[i]]$NAME = names[i]
	}
	outdata = as.data.frame(
		do.call("rbind",
			lapply(datas, function(x) { return(x[,c("CHR", "BP", "cumsum.tmp", "VAL", "NAME", "color")]) })
		)
	)

	for (i in 1:length(threshold_names)) {
		thresholds[[i]]$NAME = threshold_names[i]
	}
	outthresholds = as.data.frame(do.call("rbind", thresholds))
	return(list(outdata, outthresholds))
}

plot <- function(data, valcol, path, width, height, res_scale, thresholds, medians) {
	png(path, width = width * res_scale, height = height * res_scale, res = res_scale)
		a = ggplot(data = data) +
		geom_point(aes(x = cumsum.tmp, y = VAL, color = color)) +
		geom_hline(data = thresholds, aes(yintercept = THRESH), linetype="dashed") +
		scale_x_continuous(breaks = medians$median.x, labels = medians$CHR) +
		guides(colour=FALSE) +
		xlab("Chromosome") +
		ylab(expression(-log[10](italic(p)))) +
		scale_color_manual(values = c(gray(0.5), gray(0), "#EE2222"))+
		theme_bw() + 
		facet_grid(NAME~., scales="free_y") +
		theme(text = element_text(size=24))
		print(a)
	dev.off()
}

plot_scaled_y <- function(data, valcol, path, width, height, res_scale, thresholds, medians, scales_y) {
	png(path, width = width * res_scale, height = height * res_scale, res = res_scale)
		a = ggplot(data = data) +
		geom_point(aes(x = cumsum.tmp, y = VAL, color = color)) +
		geom_hline(data = thresholds, aes(yintercept = THRESH), linetype="dashed") +
		scale_x_continuous(breaks = medians$median.x, labels = medians$CHR) +
		guides(colour=FALSE) +
		xlab("Chromosome") +
		ylab(expression(-log[10](italic(p)))) +
		scale_color_manual(values = c(gray(0.5), gray(0), "#EE2222"))+
		theme_bw() + 
		facet_grid_sc(NAME~., scales=list(y=scales_y)) +
		theme(text = element_text(size=24))
		print(a)
	dev.off()
}
