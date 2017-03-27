#!/usr/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)
infile <- args[1]
colslist <- args[2]
cols <- as.numeric(unlist(strsplit(colslist,",")))
outfile <- args[3]
data <- as.matrix(read.table(infile))
data2 <- data[cols,cols]
write.table(data2,outfile,col.names=FALSE,row.names=FALSE)
