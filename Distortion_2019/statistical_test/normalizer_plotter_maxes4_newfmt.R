#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)

reformat_f0.4_poswin = function(data) {
	data$chrom_poswin = paste(data$chrom, data$poswin, sep = "_")
	return(data)
}

expected_transform_one = function(x) {
	if (x == "control_1") {
		return(0.51)
	} else if (x == "control_2") {
		return(0.52)
	} else if (x == "control_4") {
		return(0.54)
	} else if (x == "control_8") {
		return(0.58)
	}
	return(0.50)
}

expected_transform = function(x) {
	x = as.character(x)
	return(sapply(x, expected_transform_one))
}

get_expected_proportion = function(data) {
	data$expected_freq = expected_transform(data$experiment)
	return(data)
}
# control
# control_0
# control_1
# control_2
# control_4
# control_8
# control_sperm
# experiment
# wild_sample
# wild_xx

reformat = function(data, format, plotvar, colorvar, idvar, transform) {
	data$mean_diff = data$mean2 - data$mean1
	data$sd_diff = data$sd2 - data$sd1
	data$nlogp = -log10(data$p)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")

	if (format == "f0.4_poswin") {
		data = reformat_f0.4_poswin(data)
	}

	if ("experiment" %in% colnames(data)) {
		data = get_expected_proportion(data)
	}

	print(head(data, 2))
	print("plotvar:")
	print(plotvar)
	if (transform == "nlog") {
		data$toplot = -log10(data[,plotvar])
	} else if (transform == "abs") {
		data$toplot = abs(data[,plotvar])
	} else if (transform == "neg") {
		data$toplot = -data[,plotvar]
	} else {
		data$toplot = data[,plotvar]
	}

	print(head(data, 2))
	print("colorvar:")
	print(colorvar)
	if (colorvar == "") {
		data$tocolor = rep("", nrow(data))
	} else if (colorvar != "expected_freq") {
		data$tocolor = as.character(data[,colorvar])
	} else {
		data$tocolor = data[,colorvar]
	}
	print("idvar:")
	print(idvar)
	data$toid = data[,idvar]

	return(data)
}

plot_core = function(data2, yname, title, outpath, outtxt, colortitle, colorvar) {

	glog = ggplot(data2, aes(toid, toplot, fill = tocolor)) +
		geom_bar(stat="identity") +
		labs(x = "Sequencing sample", y = yname, title = title) +
		theme_bw() +
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

	if (colorvar == "expected_freq") {
		glog = glog + scale_fill_continuous(name = colortitle)
	} else {
		glog = glog + scale_fill_discrete(name = colortitle)
	}
		# theme(axis.text.x = element_text(angle = 22.5, vjust = 1, hjust=1)) +

	pdf(outpath, width = 40, height = 3)
	print(glog)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plotit = function(data, yname, title, outpre, colortitle, colorvar) {
	out = paste(outpre, "_plot.pdf", sep="")
	outtxt = paste(outpre, "_plot.txt", sep="")

	plot_core(data, yname, title, out, outtxt, colortitle, colorvar)
}

getmaxes = function(data, maxvar, transform) {
	if (transform == "nlog") {
		data$maxer = -log10(data[,maxvar])
	} else if (transform == "abs") {
		data$maxer = abs(data[,maxvar])
	} else if (transform == "neg") {
		data$maxer = -data[,maxvar]
	} else {
		data$maxer = data[,maxvar]
	}
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(maxer)], by=toid]$V1])
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
	colorvar = args[8]
	idvar = args[9]
	colortitle = args[10]
	maxtransform = args[11]
	plottransform = args[12]

	data = as.data.frame(fread(inpath, sep = "\t", header = TRUE))
	data = reformat(data, format, plotvar, colorvar, idvar, plottransform)

	if (length(args) > 12) {
		chrom = args[13]
		maxes = data[data$chrom == chrom,]
	} else {
		maxes = getmaxes(data, maxvar, maxtransform)
	}

	print(head(maxes))
	plotit(maxes, yname, title, outpre, colortitle, colorvar)
}

main()
