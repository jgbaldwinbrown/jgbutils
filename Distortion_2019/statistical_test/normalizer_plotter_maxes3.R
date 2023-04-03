#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)

reformat_f0.4_poswin = function(data) {
	data$chrom_poswin = paste(data$chrom, data$poswin, sep = "_")
	return(data)
}

reformat = function(data, format, plotvar) {
	print(head(data))
	data$mean_diff = data$mean2 - data$mean1
	data$sd_diff = data$sd2 - data$sd1
	data$nlogp = -log10(data$p)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	data$toplot = data[,plotvar]

	if (format == "f0.4_poswin") {
		return(reformat_f0.4_poswin(data))
	}
	return(data)
}

plot_core = function(data2, plotvar, yname, title, outpath, outtxt) {

	glog = ggplot(data2, aes(indiv_tissue, toplot)) +
		geom_bar(stat="identity") +
		labs(x = "Sequencing sample", y = yname, title = title) +
		theme_bw() +
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
		# theme(axis.text.x = element_text(angle = 22.5, vjust = 1, hjust=1)) +

	pdf(outpath, width = 40, height = 3)
	print(glog)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plotit = function(data, plotvar, yname, title, outpre) {
	out = paste(outpre, "_plot.pdf", sep="")
	outtxt = paste(outpre, "_plot.txt", sep="")

	plot_core(data, plotvar, yname, title, out, outtxt)
}

getmaxes = function(data, maxvar) {
	data$maxer = data[,maxvar]
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(maxer)], by=indiv_tissue]$V1])
	return(data2)
}

main = function() {
	args = commandArgs(trailingOnly=TRUE)
	inpath = args[1]
	format = args[2]
	outpre = args[3]
	maxvar = args[4]
	plotvar = args[5]
	yname = args[6]
	title = args[7]

	data = as.data.frame(fread(inpath, sep = "\t", header = TRUE))
	data = reformat(data, format, plotvar)

	if (length(args) > 7) {
		chrom = args[8]
		maxes = data[data$chrom == chrom,]
	} else {
		maxes = getmaxes(data, maxvar)
	}

	plotit(maxes, plotvar, yname, title, outpre)
}

main()
