library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-SNPs.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
snphistcens <- hist(snpdatacens$freq_shrimp_inbred_ill2,breaks=seq(0,1,length.out=50))
histdat <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
a <- ggplot(data=histdat,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_v1.pdf",height=3,width=4)
a
dev.off()

snpdata_95 <- filter(snpdata,freq_shrimp_inbred_ill2 >= 0.95)

library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-SNPs.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
a <- ggplot(data=histdat,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_v2.pdf",height=3,width=4)
a
dev.off()

length(alt_allele_freq_cens)
length(alt_allele_freq_cens)/2.9e9

alt95 <- alt_allele_freq_cens[alt_allele_freq_cens>=0.95]
length(alt95)
length(alt95) / 2.9e9
length(alt95) / length(alt_allele_freq_cens)

library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-INDEL.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
a <- ggplot(data=histdat,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_indel_v1.pdf",height=3,width=4)
a
dev.off()

length(alt_allele_freq_cens)
length(alt_allele_freq_cens)/2.9e9

alt95 <- alt_allele_freq_cens[alt_allele_freq_cens>=0.95]
length(alt95)
length(alt95) / 2.9e9
length(alt95) / length(alt_allele_freq_cens)

library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-SNPs.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
a <- ggplot(data=histdat,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_v2.pdf",height=3,width=4)
a
dev.off()

length(alt_allele_freq_cens)
length(alt_allele_freq_cens)/2.9e9

alt95 <- alt_allele_freq_cens[alt_allele_freq_cens>=0.95]
length(alt95)
length(alt95) / 2.9e9
length(alt95) / length(alt_allele_freq_cens)

library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-INDEL.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
a <- ggplot(data=histdat,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_indel_v1.pdf",height=3,width=4)
a
dev.off()

length(alt_allele_freq_cens)
length(alt_allele_freq_cens)/2.9e9

alt95 <- alt_allele_freq_cens[alt_allele_freq_cens>=0.95]
length(alt95)
length(alt95) / 2.9e9
length(alt95) / length(alt_allele_freq_cens)


#########################################
#########################################


library(data.table)
library(dplyr)
#/home/jbaldwin/new_home/peromyscus/bwa_alignment/v1/only-PASS-Q30-SNPs.txt
snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-SNPs.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat1 <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
histdat1$grp <- rep("A: SNP",nrow(histdat1))

snpdata <- fread("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-INDEL.txt")
snphist <- hist(snpdata$freq_shrimp_inbred_ill2,breaks=seq(-0.00001,1.00001,length.out=100))
snpdatacens <- filter(snpdata,N_shrimp_inbred_ill2 >= 10)
alt_allele_freq_cens <- (1 - snpdatacens$freq_shrimp_inbred_ill2)
snphistcens <- hist(alt_allele_freq_cens,breaks=seq(0,1,length.out=50))
histdat2 <- data.frame(mids=snphistcens$mids,counts=snphistcens$counts,density=snphistcens$density)
histdat2$grp <- rep("B: Indel",nrow(histdat1))

histdatfull <- as.data.frame(rbind(histdat1,histdat2))

a <- ggplot(data=histdatfull,aes(mids,density))+geom_bar(stat="identity",fill="black")+
  theme_bw()+
  labs(title="Allele frequency histogram for\nreference individual Illumina data",x="Allele frequency",y="Density")+
  facet_wrap(~grp)+
  theme(strip.text = element_text(hjust = 0.05),
        strip.background = element_blank())

pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_ref_allele_freq_hist_full_v1.pdf",height=3,width=6)
a
dev.off()


####manhat:

snptable <- read.table("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-SNPs.txt",
                       header=TRUE)
#chromlens <- read.table("...")
#chromlens <- data.frame(chrom=rep(NA,length(levels(factor(snptable$CHROM)))),len=rep(NA,length(levels(factor(snptable$CHROM)))))
#chromlens$chrom <- levels(factor(snptable$CHROM))
#for (i in 1:nrow(chromlens)) {
#  chromlens$len[i] <- max(inbreddat$POS[inbreddat$CHROM==chromlens$chrom[i]])
#}
#chromlens$offset <- cumsum(chromlens$len)
chromlens <- scan("/home/jbaldwin/new_home/tiger_shrimp/computed_files/refs/contig_lengths.txt")
chromnums <- read.table("/home/jbaldwin/new_home/tiger_shrimp/computed_files/refs/contig_numbers.txt",header=FALSE)
colnames(chromnums) <- c("chrom","num0")
chromnums$num1 <- chromnums$num0 + 1
chromnums$lengths <- chromlens
chromnums$offset <- c(0,cumsum(chromnums$lengths)[1:(nrow(chromnums)-1)])

inbreddat <- snptable[,c("Nmiss","CHROM","POS","REF","ALT","freq_shrimp_inbred_ill2","N_shrimp_inbred_ill2")]
inbreddat <- inbreddat[complete.cases(inbreddat),]
inbreddat$snpindex <- 1:nrow(inbreddat)
inbreddat$is_snp <- (!is.na(inbreddat$freq_shrimp_inbred_ill2)&inbreddat$freq_shrimp_inbred_ill2<1&inbreddat$freq_shrimp_inbred_ill2>0)
inbreddat$hisnps <- (inbreddat$is_snp & inbreddat$freq_shrimp_inbred_ill2 > 0.95)
inbreddat$lowsnps <- (inbreddat$is_snp & inbreddat$freq_shrimp_inbred_ill2 < 0.05)
inbreddat$midsnps <- (inbreddat$is_snp & !(inbreddat$lowsnps) & !(inbreddat$hisnps))
inbreddat$offset <- rep(NA,nrow(inbreddat))
inbreddat$notone <- apply(inbreddat,1,function(x){(min(c(as.numeric(x[6]),1-as.numeric(x[6]))<(1/as.numeric(x[7]))))})
#for (i in 1:nrow(inbreddat)){
#  inbreddat$offset[i] <- chromlens$offset[chromlens$chrom==inbreddat$CHROM[i]]
#}
#inbreddat$offset2 <- apply(inbreddat,1,function(x){chromnums$offset[chromnums$chrom==x[2]]})
library(hash)
offsethash <- hash(keys=chromnums$chrom,values=chromnums$offset)
inbreddat$offset2 <- apply(inbreddat,1,function(x){offsethash[[x[2]]]})
inbreddat$plotpos <- inbreddat$POS+inbreddat$offset2

mybins <- seq(min(inbreddat$plotpos),max(inbreddat$plotpos),by=1000000)
mymids <- mybins[1:(length(mybins)-1)]+50000
mysum_snps <- sapply(mybins,function(x){sum(inbreddat$is_snp[inbreddat$plotpos >= x & inbreddat$plotpos < x+100000])})[1:length(mymids)]
mysum_hisnps <- sapply(mybins,function(x){sum(inbreddat$hisnps[inbreddat$plotpos >= x & inbreddat$plotpos < x+100000])})[1:length(mymids)]
mysum_lowsnps <- sapply(mybins,function(x){sum(inbreddat$lowsnps[inbreddat$plotpos >= x & inbreddat$plotpos < x+100000])})[1:length(mymids)]
mysum_midsnps <- sapply(mybins,function(x){sum(inbreddat$midsnps[inbreddat$plotpos >= x & inbreddat$plotpos < x+100000])})[1:length(mymids)]
mysum_notonesnps <- sapply(mybins,function(x){sum(inbreddat$notone[inbreddat$plotpos >= x & inbreddat$plotpos < x+100000])})[1:length(mymids)]
mysum_chrs <- rep(NA,length(mymids))
for (i in 1:length(mysum_chrs)){
  temp <- as.character(chromnums$chrom[(chromnums$offset - mymids[i])>=0])
  #mysum_chrs[i] <- temp[median(1:length(temp))]
  mysum_chrs[i] <- temp[1]
}
mysum_num1 <- rep(NA,length(mymids))
for (i in 1:length(mysum_chrs)){
  temp <- as.numeric(chromnums$num1[(chromnums$offset - mymids[i])<0])
  mysum_num1[i] <- temp[length(temp)]
}

fullwins <- data.frame(mids=mymids,snps=mysum_snps,hisnps=mysum_hisnps,lowsnps=mysum_lowsnps,midsnps=mysum_midsnps,notonesnps=mysum_notonesnps,
                       chrs=mysum_chrs,num1=mysum_num1)
mfullwins <- melt(fullwins,id.vars=c("mids","chrs","num1"))
a <- ggplot(data=mfullwins[mfullwins$variable=="midsnps",],aes(mids/1e6,value,color=factor(num1),fill=factor(num1)))+
  geom_bar(stat="identity",size=0.5)+
  guides(color=FALSE,fill=FALSE)+
  scale_color_discrete(h=c(0,0),c=c(0,0),l=c(0,66))+
  scale_fill_discrete(h=c(0,0),c=c(0,0),l=c(0,66))+
  theme_bw(base_size=48)+
  scale_x_continuous("Position (Mb)")+
  scale_y_continuous("Count")+
  ggtitle("Histogram of polymorphic SNPs\nalong the genome (1Mb bins)")
a
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_shrimp_inbred_poly_histo.pdf",
    width=32,height=24)
a
dev.off()

chromsnpdens <- rep(NA,length(chromlens))
chromsnps <- rep(NA,length(chromlens))
for (i in 1:length(chromlens)) {
  chromsnps[i] <- sum(fullwins$midsnps[fullwins$num1==i])
  chromsnpdens[i] <- sum(fullwins$midsnps[fullwins$num1==i])/chromlens[i]
}
plot(1:length(chromsnpdens),chromsnpdens)
plot(1:length(chromsnpdens),cumsum(chromsnpdens))

cso <- chromsnps[order(chromsnpdens,decreasing = TRUE)]
csdo <- chromsnpdens[order(chromsnpdens,decreasing = TRUE)]
clo <- chromlens[order(chromsnpdens,decreasing=TRUE)]
plot(cumsum(clo),cumsum(cso))
plot(clo,csdo)

dstat <- data.frame(cumsum(clo),clo,cso,csdo,cumsum(cso),cumsum(cso)/sum(cso))


#library(qqman)
#manhattan(fullwins,bp=mids,)


#plot(mymids,mysum_midsnps)+
  abline(v=chromnums$offset)

####manhat indels:

snptable_indel <- read.table("/home/jbaldwin/new_home/tiger_shrimp/computed_files/only-PASS-Q30-INDEL.txt",
                       header=TRUE)
#chromlens <- read.table("...")
#chromlens <- data.frame(chrom=rep(NA,length(levels(factor(snptable$CHROM)))),len=rep(NA,length(levels(factor(snptable$CHROM)))))
#chromlens$chrom <- levels(factor(snptable$CHROM))
#for (i in 1:nrow(chromlens)) {
#  chromlens$len[i] <- max(inbreddat$POS[inbreddat$CHROM==chromlens$chrom[i]])
#}
#chromlens$offset <- cumsum(chromlens$len)
chromlens_indel <- scan("/home/jbaldwin/new_home/tiger_shrimp/computed_files/refs/contig_lengths.txt")
chromnums_indel <- read.table("/home/jbaldwin/new_home/tiger_shrimp/computed_files/refs/contig_numbers.txt",header=FALSE)
colnames(chromnums_indel) <- c("chrom","num0")
chromnums_indel$num1 <- chromnums_indel$num0 + 1
chromnums_indel$lengths <- chromlens_indel
chromnums_indel$offset <- c(0,cumsum(chromnums_indel$lengths)[1:(nrow(chromnums_indel)-1)])

inbreddat_indel <- snptable_indel[,c("Nmiss","CHROM","POS","REF","ALT","freq_shrimp_inbred_ill2","N_shrimp_inbred_ill2")]
inbreddat_indel <- inbreddat_indel[complete.cases(inbreddat_indel),]
inbreddat_indel$snpindex <- 1:nrow(inbreddat_indel)
inbreddat_indel$is_snp <- (!is.na(inbreddat_indel$freq_shrimp_inbred_ill2)&inbreddat_indel$freq_shrimp_inbred_ill2<1&inbreddat_indel$freq_shrimp_inbred_ill2>0)
inbreddat_indel$hisnps <- (inbreddat_indel$is_snp & inbreddat_indel$freq_shrimp_inbred_ill2 > 0.9)
inbreddat_indel$lowsnps <- (inbreddat_indel$is_snp & inbreddat_indel$freq_shrimp_inbred_ill2 < 0.1)
inbreddat_indel$midsnps <- (inbreddat_indel$is_snp & !(inbreddat_indel$lowsnps) & !(inbreddat_indel$hisnps))
inbreddat_indel$offset <- rep(NA,nrow(inbreddat_indel))
inbreddat_indel$notone <- apply(inbreddat_indel,1,function(x){(min(c(as.numeric(x[6]),1-as.numeric(x[6]))<(1/as.numeric(x[7]))))})
#for (i in 1:nrow(inbreddat)){
#  inbreddat$offset[i] <- chromlens$offset[chromlens$chrom==inbreddat$CHROM[i]]
#}
#inbreddat$offset2 <- apply(inbreddat,1,function(x){chromnums$offset[chromnums$chrom==x[2]]})
library(hash)
offsethash_indel <- hash(keys=chromnums_indel$chrom,values=chromnums_indel$offset)
inbreddat_indel$offset2 <- apply(inbreddat_indel,1,function(x){offsethash_indel[[x[2]]]})
inbreddat_indel$plotpos <- inbreddat_indel$POS+inbreddat_indel$offset2

mybins_indel <- seq(min(inbreddat_indel$plotpos),max(inbreddat_indel$plotpos),by=1000000)
mymids_indel <- mybins_indel[1:(length(mybins_indel)-1)]+500000
mysum_snps_indel <- sapply(mybins_indel,function(x){sum(inbreddat_indel$is_snp[inbreddat_indel$plotpos >= x & inbreddat_indel$plotpos < x+100000])})[1:length(mymids_indel)]
mysum_hisnps_indel <- sapply(mybins_indel,function(x){sum(inbreddat_indel$hisnps[inbreddat_indel$plotpos >= x & inbreddat_indel$plotpos < x+100000])})[1:length(mymids_indel)]
mysum_lowsnps_indel <- sapply(mybins_indel,function(x){sum(inbreddat_indel$lowsnps[inbreddat_indel$plotpos >= x & inbreddat_indel$plotpos < x+100000])})[1:length(mymids_indel)]
mysum_midsnps_indel <- sapply(mybins_indel,function(x){sum(inbreddat_indel$midsnps[inbreddat_indel$plotpos >= x & inbreddat_indel$plotpos < x+100000])})[1:length(mymids_indel)]
mysum_notonesnps_indel <- sapply(mybins_indel,function(x){sum(inbreddat_indel$notone[inbreddat_indel$plotpos >= x & inbreddat_indel$plotpos < x+100000])})[1:length(mymids_indel)]
mysum_chrs_indel <- rep(NA,length(mymids_indel))
for (i in 1:length(mysum_chrs_indel)){
  temp_indel <- as.character(chromnums_indel$chrom[(chromnums_indel$offset - mymids_indel[i])>=0])
  #mysum_chrs[i] <- temp[median(1:length(temp))]
  mysum_chrs_indel[i] <- temp_indel[1]
}
mysum_num1_indel <- rep(NA,length(mymids_indel))
for (i in 1:length(mysum_chrs_indel)){
  temp_indel <- as.numeric(chromnums_indel$num1[(chromnums_indel$offset - mymids_indel[i])<0])
  mysum_num1_indel[i] <- temp_indel[length(temp_indel)]
}

fullwins_indel <- data.frame(mids=mymids_indel,snps=mysum_snps_indel,hisnps=mysum_hisnps_indel,lowsnps=mysum_lowsnps_indel,midsnps=mysum_midsnps_indel,notonesnps=mysum_notonesnps_indel,
                       chrs=mysum_chrs_indel,num1=mysum_num1_indel)
mfullwins_indel <- melt(fullwins_indel,id.vars=c("mids","chrs","num1"))
a <- ggplot(data=mfullwins_indel[mfullwins_indel$variable=="midsnps",],aes(mids/1e6,value,color=factor(num1),fill=factor(num1)))+
  geom_bar(stat="identity",size=0.5)+
  guides(color=FALSE,fill=FALSE)+
  scale_color_discrete(h=c(0,0),c=c(0,0),l=c(0,66))+
  scale_fill_discrete(h=c(0,0),c=c(0,0),l=c(0,66))+
  theme_bw(base_size=48)+
  scale_x_continuous("Position (Mb)")+
  scale_y_continuous("Count")+
  ggtitle("Histogram of heterozygous\nsites along the genome (1Mb bins)")
a
pdf("/home/jbaldwin/new_home/tiger_shrimp/figures/tiger_shrimp_inbred_poly_histo_indel.pdf",
    width=32,height=24)
a
dev.off()

chromsnpdens_indel <- rep(NA,length(chromlens_indel))
chromsnps_indel <- rep(NA,length(chromlens_indel))
for (i in 1:length(chromlens_indel)) {
  chromsnps_indel[i] <- sum(fullwins_indel$midsnps[fullwins_indel$num1==i])
  chromsnpdens_indel[i] <- sum(fullwins_indel$midsnps[fullwins_indel$num1==i])/chromlens_indel[i]
}
plot(1:length(chromsnpdens_indel),chromsnpdens_indel)
plot(1:length(chromsnpdens_indel),cumsum(chromsnpdens_indel))

cso_indel <- chromsnps_indel[order(chromsnpdens_indel,decreasing = TRUE)]
csdo_indel <- chromsnpdens_indel[order(chromsnpdens_indel,decreasing = TRUE)]
clo_indel <- chromlens_indel[order(chromsnpdens_indel,decreasing=TRUE)]
plot(cumsum(clo_indel),cumsum(cso_indel))
plot(clo_indel,csdo_indel)

dstat <- data.frame(cumsum(clo_indel),clo_indel,cso_indel,csdo_indel,cumsum(cso_indel),cumsum(cso_indel)/sum(cso_indel))


#library(qqman)
#manhattan(fullwins,bp=mids,)


#plot(mymids,mysum_midsnps)+
  abline(v=chromnums_indel$offset)



