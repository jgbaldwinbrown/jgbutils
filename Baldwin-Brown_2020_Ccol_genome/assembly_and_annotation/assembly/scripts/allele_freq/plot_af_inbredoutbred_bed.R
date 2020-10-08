#!/usr/bin/env Rscript

library(ggplot2)

args=commandArgs(trailingOnly=TRUE)

inpathinbred=args[1]
inpathoutbred=args[2]
outpath=args[3]
data_inbred=read.table(inpathinbred,header=FALSE,sep="\t")
data_outbred=read.table(inpathoutbred,header=FALSE,sep="\t")
data_inbred$Population=rep("Inbred",nrow(data_inbred))
data_outbred$Population=rep("Outbred",nrow(data_outbred))

data=as.data.frame(rbind(data_inbred,data_outbred))
colnames(data)=colnames(data_inbred)

pdf(outpath,height=3,width=4)
ggplot(data=data,aes(V6))+geom_histogram(bins=100)+
    facet_grid(Population~.)+
    labs(title="Allele frequency histogram",x="Allele frequency",y="Count")+
    theme_bw()
dev.off()


