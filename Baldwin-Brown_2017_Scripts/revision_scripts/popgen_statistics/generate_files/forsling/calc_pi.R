#!/usr/bin/Rscript

cov = read.table("JBB_hb705_forsling_covs_1chr_correct.txt")
colnames(cov) = c("L","n")	 					# uniq -c  count \t category --->>> n = depth
L=sum(cov$L[cov$n>25])
RC = read.table("raw.count.txt")
T = RC[,1] + RC[,2]
RC = RC[T > 25,]
T = T[T>25]
PI = (2*RC[,1]*RC[,2])/T^2
pi = sum(PI)/L                        
head(L)
head(RC)
head(T)
head(PI)
sum(PI)
pi

