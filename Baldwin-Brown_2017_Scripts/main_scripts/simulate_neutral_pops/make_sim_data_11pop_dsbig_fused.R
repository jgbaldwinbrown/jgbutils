#!/usr/bin/Rscript

source("baypass_utils.R")
set.seed(5784329)

omat <- as.matrix(read.table("shrimp_matrix_11_standard_final.txt"))

#c <- simulate.baypass(omat,nsnp=20000,remove.fixed.loci=TRUE,suffix=baypass_sim_test,sample.size=200,coverage=c(30,40,30,35,40,50,40,33,39,54,100,10))
covs <- c(39.3,(12.38+26.49),28.64,24.69,25.03,25.97,(78.66/2),46.18,47.73,24.45,(100.18/3))
rcovs <- round(covs)
outdata <- simulate.baypass(omat,nsnp=40000000,remove.fixed.loci=TRUE,suffix="baypass_sim_dsbig_fused",sample.size=200,coverage=rcovs)


