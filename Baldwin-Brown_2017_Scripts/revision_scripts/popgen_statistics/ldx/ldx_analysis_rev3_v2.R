#!/usr/bin/Rscript
ld11_1 <- read.table("ldx_out_forsling.txt")
mean(ld11_1$V13)
r2perbp <- (1-ld11_1$V13) / (ld11_1$V2-ld11_1$V1)
r2perbp2 <- ld11_1$V13 / (ld11_1$V2-ld11_1$V1)
dist <- ld11_1$V2-ld11_1$V1
dists <- levels(factor(dist))
distmean <- sapply(X = dists,FUN = function(x) {mean(ld11_1$V13[dist==as.numeric(x)])})
1-mean(r2perbp)
mean(r2perbp2)
no0 <- ld11_1[ld11_1$V13!=0,]

plot((ld11_1$V2-ld11_1$V1),ld11_1$V13)
plot((no0$V2-no0$V1),no0$V13)

plot(dists,distmean)
lines(dists,smooth.spline(distmean,spar = .9)$y)
plot(dists,smooth.spline(distmean,spar = .9)$y)

##read in all ld tables:
fulldata_ld <- ld11_1
colnames(fulldata_ld) <- c("pos1","pos2","x11","x12","x21","x22","afA","afB","depth1","depth2","intdepth","MLElow","MLE","MLEhigh","directr","A","a","B","b")
fulldata_ld$dist = fulldata_ld$pos2 - fulldata_ld$pos1

write.table(fulldata_ld,file="fulldata_ld_refv3.txt")

#function for getting mean for each population

dists=levels(factor(fulldata_ld$dist))
bigdistmean <- sapply(X = dists,FUN = function(x) {mean(fulldata_ld$MLE[fulldata_ld$dist==as.numeric(x)])})
write.table(bigdistmean,"bigdistmean_refv3.txt")
