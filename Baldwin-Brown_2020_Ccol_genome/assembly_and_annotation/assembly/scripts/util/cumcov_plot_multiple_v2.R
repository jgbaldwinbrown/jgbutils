#!/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

inpath1 <- args[1]
inpath2 <- args[2]
inpath3 <- args[3]
mytitle <- args[4]
outpath <- args[5]

data1 <- read.table(inpath1)$V1
sorted_data1 <- sort(data1,decreasing=TRUE)
mycumsum1 <- cumsum(sorted_data1)

data2 <- read.table(inpath2)$V1
sorted_data2 <- sort(data2,decreasing=TRUE)
mycumsum2 <- cumsum(sorted_data2)

data3 <- read.table(inpath3)$V1
sorted_data3 <- sort(data3,decreasing=TRUE)
mycumsum3 <- cumsum(sorted_data3)

sorted_data <- c(sorted_data1,sorted_data2,sorted_data3)
mycumsum <- c(mycumsum1,mycumsum2,mycumsum3)
idents <- c(rep("Canu assembly v2",length(sorted_data1)),rep("Canu assembly v1",length(sorted_data2)),rep("CLC assembly v1",length(sorted_data3)))

fulldat <- data.frame(sorted_lengths=sorted_data,mycumsum=mycumsum,idents=idents)

str(fulldat)

myplot <- ggplot(data=fulldat,aes(sorted_lengths,mycumsum,color=factor(idents)))+
    geom_line()+
    geom_point()+
    theme_bw()+
    scale_x_reverse()+
    labs(title=mytitle,xlab="Contig Lengths",ylab="Cumulative Genome Coverage")+
    scale_color_discrete(name="Assembly")

pdf(outpath,height=4,width=6)
myplot
dev.off()

