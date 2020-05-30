ld11_1 <- read.table("../ldx_out_forsling.txt")
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
plot(dists,bigdistmean)
disttable <- as.data.frame(cbind(dists,bigdistmean))
disttablefin <- disttable[is.finite(as.numeric(disttable$bigdistmean)),]
plot(disttablefin$dists,smooth.spline(disttablefin$bigdistmean,spar=.8)$y)
plot(as.numeric(disttablefin$dists),as.numeric(disttablefin$bigdistmean))

#dma2 <- t(distmeanall)
#colnames(dma2) <- 1:12
#library(reshape)
#dma3 <- melt(dma2)
#library(ggplot2)
#qplot(X1,value,data=dma3,color=factor(X2))+
#  geom_smooth()
#
#dma4 <- dma2
#colnames(dma4) <- c('Cassidy','WAL','Hayden','JT4','Forsling','Ares','LTER','AMT1','SWP4','JD1','Tank011','EE_ancestor')
#dma5 <- melt(dma4)
#library(ggplot2)
#
#aplot <- qplot(X1,value,data=dma5,color=factor(X2))+
#  geom_smooth()+
#  scale_color_discrete(name="Population")+
#  ggtitle("Short distance linkage disequilibrium")+
#  scale_x_continuous(name="Distance (bp)")+
#  scale_y_continuous(name="r^2 (approximate)")
#
#tiff("ldx_plot_v1.tif",
#     width=6*800, height=4*800, res=800, compression="lzw")
#aplot
#dev.off()
