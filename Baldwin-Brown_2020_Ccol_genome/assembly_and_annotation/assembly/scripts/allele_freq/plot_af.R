#!/usr/bin/env Rscript

library(ggplot2)

args=commandArgs(trailingOnly=TRUE)

inpath=args[1]
outpath=args[2]

data=read.table(inpath,header=TRUE)

pdf(outpath,height=3,width=4)
ggplot(data=data,aes(freq_all_out))+geom_histogram(bins=100)+
    labs(title="Allele frequency histogram",x="Allele frequency",y="Count")
dev.off()
