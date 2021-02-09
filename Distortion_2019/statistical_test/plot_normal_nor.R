#!/usr/bin/env Rscript

library(data.table)

args = commandArgs(trailingOnly=TRUE)

gc = as.data.frame(fread("gc_new.txt", header=FALSE))
colnames(gc) = c("chrom","gc")
goodchroms = gc$chrom

data = as.data.frame(fread(args[1], header=TRUE))
pdata = data[data$chrom %in% goodchroms,]



#"sample" "chrom" "tissue" "x" "sample_chrom_tissue" "p"
#"1" "15458X12" "NC_000001.11" "Blood" NA "15458X12_NC_000001.11_Blood" 1.04745392001381e-23
#"2" "15458X15" "NC_000001.11" "Blood" NA "15458X15_NC_000001.11_Blood" 0.000424621290569115
#"3" "15458X17" "NC_000001.11" "Blood" -1.60130273363701 "15458X17_NC_000001.11_Blood" 0.0764568572539828
#"4" "15458X21" "NC_000001.11" "Blood" NA "15458X21_NC_000001.11_Blood" 0.000289284218923935
#"5" "15458X23" "NC_000001.11" "Blood" -1.59080731813253 "15458X23_NC_000001.11_Blood" 8.16633870304173e-07
#"6" "15458X25" "NC_000001.11" "Blood" NA "15458X25_NC_000001.11_Blood" 3.36064509554035e-12
#"7" "15458X27" "NC_000001.11" "Blood" NA "15458X27_NC_000001.11_Blood" 0.12959987911891
#"8" "15458X29" "NC_000001.11" "Blood" NA "15458X29_NC_000001.11_Blood" 0.00959823353504478
#"9" "15458X4" "NC_000001.11" "Blood" NA "15458X4_NC_000001.11_Blood" 3.54734151611301e-06
