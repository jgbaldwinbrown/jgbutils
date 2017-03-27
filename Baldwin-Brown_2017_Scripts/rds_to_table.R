#!/usr/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)
infile <- args[1]
outfile <- args[2]

write.table(readRDS(infile),outfile)

