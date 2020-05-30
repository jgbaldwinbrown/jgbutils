#!/usr/bin/Rscript

pop = read.table("countem.txt",header=TRUE)
cov = read.table("JBB_hb705_forsling_covs_1chr_correct.txt")
colnames(cov) = c("L","n")	 					# uniq -c  count \t category --->>> n = depth
b = merge(pop,cov)    # n is the common column
b$theta = b$Nsites / (b$phi*b$L)      					#  theta_hat {i,n}
totalphi = sum(b$phi)							#  SUM phi (conditioning on allele frequency in prior script)
b$w = (b$L*b$phi)/totalphi						#  w{i,n}
Theta = sum(b$w*b$theta)/sum(b$w)					#  weighted estimate of theta, over all site in MAF > 10% and coverage > 10
print(Theta)
