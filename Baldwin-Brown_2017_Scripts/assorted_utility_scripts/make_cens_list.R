#!/bin/Rscript

library(ggplot2)
library(ape)

args <- commandArgs(trailingOnly = TRUE)

infile <- as.character(args[1])
mincov <- as.numeric(args[2])
maxcov <- as.numeric(args[3])
covsdthresh <- as.numeric(args[4])
outpath <- as.character(args[5])
numpops <- as.numeric(args[6])

#get data:


snp_table2 <- read.table(infile,header=TRUE)
#numpops <- (ncol(snp_table2) - 5) / 2
#freqindices <- seq(6,ncol(snp_table2),2)
#covindices <- seq(7,ncol(snp_table2),2)
freqindices <- seq(6,5+(numpops*2),2)
covindices <- seq(7,5+(numpops*2),2)
trunc_snp2 <- snp_table2[,freqindices]
colnames(trunc_snp2) <- 1:numpops


## censor data:
snp2_cov <- snp_table2[,covindices]
snp2_totcov <- apply(snp2_cov,1,sum)
mean(snp2_totcov,na.rm=TRUE)
m <- mean(snp2_totcov)
sd(snp2_totcov,na.rm=TRUE)
s <- sd(snp2_totcov)


snp_table2$totcov <- snp2_totcov
snp_table_good <- data.frame(index=1:nrow(snp_table2),good=rep(TRUE,nrow(snp_table2)))
snp_table_good$good <- snp_table_good$good & snp2_totcov>=(m-covsdthresh*s)&snp2_totcov<=(m+covsdthresh*s)
meancovs <- apply(snp_table2[,covindices],2,mean)
sdcovs <- apply(snp_table2[,covindices],2,sd)
for (i in 1:numpops) {
    mycov <- snp_table2[,covindices[i]]
    mycovmean <- meancovs[i]
    mysdmean <- sdcovs[i]
    myfreq <- snp_table2[,freqindices[i]]
    myhits <- myfreq * mycov
    myabsdist <- abs(mycovmean - mycov)
    snp_table_good$good <- snp_table_good$good & mycov>=mincov &
                 mycov<=maxcov &
                 myabsdist<=(mysdmean * 2)
}

write.table(snp_table_good,outpath,row.names=FALSE,col.names=FALSE)

#myhits>=minhits
#myfreq >= minfreq

