#!/usr/bin/env Rscript

library(ggplot2)
library(data.table)

main = function() {
	args = commandArgs(trailingOnly=TRUE)
	data = as.data.frame(fread(args[1], header=TRUE))

	p = ggplot(data, aes(gen, minor_f, color = factor(repl))) + 
		geom_line() +
		geom_point() +
		labs(title = "Allele frequencies over time", x = "Time (months)", y = "Minor allele frequency") +
		scale_color_discrete(name = "Replicate") +
		theme_bw()

	pdf(args[2], height = 3, width = 4)
		print(p)
	dev.off()
}

main()
