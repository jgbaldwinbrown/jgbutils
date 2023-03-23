#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)

reformat_f0.1 = function(data) {
	colnames(data) = c("tissue", "indiv_chrom_tissue_poswin", "f", "df1", "df2", "p")
	return(data)
}

reformat_f0.2 = function(data) {
	colnames(data) = c(
		"control_tissue",
		"indiv_chrom_tissue",
		"count1", "count2",
		"mean1", "mean2",
		"sd1", "sd2",
		"f",
		"df1",
		"df2",
		"p",
		"indiv",
		"chrom",
		"tissue"
	)
	return(data)
}

reformat_f0.2_poswin = function(data) {
	colnames(data) = c(
		"control_tissue",
		"indiv_chrom_tissue_poswin",
		"count1", "count2",
		"mean1", "mean2",
		"sd1", "sd2",
		"f",
		"df1",
		"df2",
		"p",
		"indiv",
		"chrom",
		"tissue",
		"poswin"
	)
	data$chrom_poswin = paste(data$chrom, data$poswin, sep = "_")
	return(data)
}

# tissue	indiv_chrom_tissue_poswin	f	df1	df2	p

# blood	191_1_sperm_190000000	1.7549535830059868	5.282665e+06	22	0.10939681532064749
# blood	209_2_sperm_46000000	0.5629333072504628	5.282665e+06	56	0.000622801995450467
# blood	84_9_sperm_107000000	0.5514504116525193	5.282665e+06	77	3.329515998116224e-05
# blood	6_X_sperm_155000000	0.6217225775477382	5.282665e+06	9	0.21275016519773318
# blood	62_1_sperm_197000000	0.19548121428896606	5.282665e+06	15	5.498120145846482e-10
# blood	70_13_sperm_53000000	0.29762558633061886	5.282665e+06	36	8.155758038401044e-11
# blood	80_3_sperm_90000000	4.515864650101982	5.282665e+06	7	0.038950682427670635
# blood	113_7_sperm_67000000	0.17752615659361784	5.282665e+06	39	9.729885581306532e-27
# blood	152_13_sperm_82000000	1.4831885101345024	5.282665e+06	17	0.33684802778537204
# blood	218_5_sperm_128000000	1.3552737690895076	5.282665e+06	23	0.3786308593922103


reformat = function(data, format) {
	if (format == "f0.2") {
		return(reformat_f0.2(data))
	} else if (format == "f0.2_poswin") {
		return(reformat_f0.2_poswin(data))
	}
}

# library(data.table)
# a = as.data.table(mtcars)
# b = as.data.frame(a[a[, .I[which.max(mpg)], by=cyl]$V1])

plot_meandiff = function(data, outpath, outtxt) {
	data$meandiff = abs(data$mean2 - data$mean1)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(meandiff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, meandiff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_sddiff = function(data, outpath, outtxt) {
	data$sddiff = abs(data$sd2 - data$sd1)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(sddiff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, sddiff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_meandiff_poswin = function(data, outpath, outtxt) {
	data$meandiff = abs(data$mean2 - data$mean1)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(meandiff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, meandiff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_sddiff_poswin = function(data, outpath, outtxt) {
	data$sddiff = abs(data$sd2 - data$sd1)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(sddiff)], by=indiv_tissue]$V1])
	g = ggplot(data2, aes(indiv_tissue, sddiff)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)


	pdf(outpath, width = 8, height = 3)
	print(g)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_logp = function(data, outpath, outtxt) {
	data$nlogp = -log10(data$p)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(nlogp)], by=indiv_tissue]$V1])
	glog = ggplot(data2, aes(indiv_tissue, nlogp)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)

	pdf(outpath, width = 8, height = 3)
	print(glog)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plot_logp_poswin = function(data, outpath, outtxt) {
	data$nlogp = -log10(data$p)
	data$indiv_tissue = paste(data$indiv, data$tissue, sep="_")
	datat = as.data.table(data)
	data2 = as.data.frame(datat[datat[, .I[which.max(nlogp)], by=indiv_tissue]$V1])
	glog = ggplot(data2, aes(indiv_tissue, nlogp)) +
		geom_bar(stat="identity") +
		ggtitle(outpath)

	pdf(outpath, width = 8, height = 3)
	print(glog)
	dev.off()

	write.table(data2, outtxt, quote=FALSE, sep="\t", row.names=FALSE)
}

plotit = function(data, outpre) {
	out2 = paste(outpre, "_log10_plot.pdf", sep="")
	out2txt = paste(outpre, "_log10_plot.txt", sep="")
	out3 = paste(outpre, "_meandiff_plot.pdf", sep="")
	out3txt = paste(outpre, "_meandiff_plot.txt", sep="")
	out4 = paste(outpre, "_sddiff_plot.pdf", sep="")
	out4txt = paste(outpre, "_sddiff_plot.txt", sep="")

	plot_logp(data, out2, out2txt)
	plot_meandiff(data, out3, out3txt)
	plot_sddiff(data, out4, out4txt)
}

plotit_poswin = function(data, outpre) {
	out2 = paste(outpre, "_log10_plot.pdf", sep="")
	out2txt = paste(outpre, "_log10_plot.txt", sep="")
	out3 = paste(outpre, "_meandiff_plot.pdf", sep="")
	out3txt = paste(outpre, "_meandiff_plot.txt", sep="")
	out4 = paste(outpre, "_sddiff_plot.pdf", sep="")
	out4txt = paste(outpre, "_sddiff_plot.txt", sep="")

	plot_logp_poswin(data, out2, out2txt)
	plot_meandiff_poswin(data, out3, out3txt)
	plot_sddiff_poswin(data, out4, out4txt)
}

main = function() {
	args = commandArgs(trailingOnly=TRUE)
	inpath = args[1]
	format = args[2]
	outpre = args[3]

	data = as.data.frame(fread(inpath, sep = "\t", header = FALSE))
	data = reformat(data, format)

	if (format == "f0.2") {
		plotit(data, outpre)
	} else if (format == "f0.2_poswin") {
		plotit_poswin(data, outpre)
	}
}

main()
