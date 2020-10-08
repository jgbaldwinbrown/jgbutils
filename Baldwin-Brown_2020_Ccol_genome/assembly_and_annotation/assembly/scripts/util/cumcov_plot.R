#!/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

inpath <- args[1]
mytitle <- args[2]
outpath <- args[3]

data <- read.table(inpath)$V1
sorted_data <- sort(data,decreasing=TRUE)
mycumsum <- cumsum(sorted_data)
fulldat <- data.frame(sorted_lengths=sorted_data,mycumsum=mycumsum)

myplot <- ggplot(data=fulldat,aes(sorted_lengths,mycumsum))+
    geom_line()+
    geom_point()+
    theme_bw()+
    scale_x_reverse()+
    labs(title=mytitle,xlab="Contig Lengths",ylab="Cumulative Genome Coverage")

pdf(outpath,height=4,width=6)
myplot
dev.off()
