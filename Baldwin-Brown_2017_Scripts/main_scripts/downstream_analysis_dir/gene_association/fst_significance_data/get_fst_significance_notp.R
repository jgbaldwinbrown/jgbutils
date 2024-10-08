#!/bin/Rscript

args = commandArgs(trailingOnly=TRUE)

inpath = args[1]
alpha = as.numeric(args[2])
outpath = args[3]

if (grepl(".RDS",inpath)) {
    data <- readRDS(inpath)
} else if (grepl(".txt",inpath)) {
    data <- read.table(inpath,header=TRUE)
} else {
    quit()
}

getlambda <- function(x) {
    return(1/mean(x,na.rm=TRUE))
}

getp <- function(x,lambda) {
    return(1-pexp(x,lambda))
}

sig <- function(x,thresh) {
    return(x <= thresh)
}

getq <- function(x,lambda) {
    return(qexp(1-x,lambda))
}

lambda = getlambda(data$fst_mean_win25)
data$pval = sapply(data$fst_mean_win25,function(x){getp(x,lambda)})

thresh = alpha / length(data$fst_mean_win25)
fst_thresh = getq(thresh,lambda)
write(fst_thresh,"fst_mean_sigthresh_fst_nowin.txt")
write(lambda,"fst_mean_lambda_nowin.txt")

#data$significant = sapply(data$pval,function(x){sig(x,thresh)})

#outtable = data[,c("CHROM","POS","fst_mean_win25","pval","significant")]

#write.table(outtable,outpath)
