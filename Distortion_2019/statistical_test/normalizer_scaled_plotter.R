#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)

reformat_f0.3_poswin = function(data) {
	data$chrom_poswin = paste(data$chrom, data$poswin, sep = "_")
	return(data)
}


reformat = function(data, format) {
	if (format == "t0.3") {
		return(data)
	} else if (format == "f0.3_poswin") {
		return(reformat_f0.3_poswin(data))
	} else {
		quit(status=1)
	}
}

plot_scaled_meandiff = function(data, outpath) {
	g = ggplot(data, aes(chrom, mean_diff)) +
		geom_bar(stat="identity") +
		facet_grid(indiv ~ tissue) +
		ggtitle(outpath)


	pdf(outpath, width = 4, height = 10)
	print(g)
	dev.off()
}

plot_scaled_sddiff_poswin = function(data, outpath) {
	g = ggplot(data, aes(chrom_poswin, sd_diff)) +
		geom_bar(stat="identity") +
		facet_grid(indiv ~ tissue) +
		ggtitle(outpath)


	pdf(outpath, width = 4, height = 10)
	print(g)
	dev.off()
}

plotit = function(data, outpre) {
	out3 = paste(outpre, "_scaled_meandiff_plot.pdf", sep="")

	plot_scaled_meandiff(data, out3)
}

plotit_poswin = function(data, outpre) {
	out4 = paste(outpre, "_scaled_sddiff_plot.pdf", sep="")

	plot_scaled_sddiff_poswin(data, out4)
}

main = function() {
	args = commandArgs(trailingOnly=TRUE)
	inpath = args[1]
	format = args[2]
	myindiv = args[3]
	outpre = args[4]

	data = as.data.frame(fread(inpath, sep = "\t", header = TRUE))
	data = reformat(data, format)
	minidata = data[data$indiv == myindiv,]

	if (format == "t0.3") {
		plotit(minidata, outpre)
		plotit_maxes(data, outpre)
	} else if (format == "f0.3_poswin") {
		plotit_poswin(minidata, outpre)
		plotit_poswin_maxes(data, outpre)
	}
}

plot_meandiff_maxes = function(data, outpath, outtxt) {
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(mean_diff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, mean_diff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_sddiff_poswin_maxes = function(data, outpath, outtxt) {
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(sd_diff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, sd_diff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plotit_maxes = function(data, outpre) {
	out3 = paste(outpre, "_scaled_meandiff_maxes_plot.pdf", sep="")
	out3txt = paste(outpre, "_scaled_meandiff_maxes_plot.txt", sep="")

	plot_meandiff_maxes(data, out3, out3txt)
}

plotit_poswin_maxes = function(data, outpre) {
	out4 = paste(outpre, "_scaled_sddiff_maxes_plot.pdf", sep="")
	out4txt = paste(outpre, "_scaled_sddiff_maxes_plot.txt", sep="")

	plot_sddiff_poswin_maxes(data, out4, out4txt)
}

main()
