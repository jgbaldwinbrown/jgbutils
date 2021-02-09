#!/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

inpath1 <- args[1]
inpath2 <- args[2]
mytitle <- args[3]
outpath <- args[4]

data1 <- read.table(inpath1)$V1
sorted_data1 <- sort(data1,decreasing=TRUE)
mycumsum1 <- cumsum(sorted_data1)

data2 <- read.table(inpath2)$V1
sorted_data2 <- sort(data2,decreasing=TRUE)
mycumsum2 <- cumsum(sorted_data2)

sorted_data <- c(sorted_data1,sorted_data2)
mycumsum <- c(mycumsum1,mycumsum2)
idents <- c(rep("Hi-C\nscaffolded\nassembly",length(sorted_data1)),rep("Canu-\nassembled\ncontigs",length(sorted_data2)))

fulldat <- data.frame(sorted_lengths=sorted_data,mycumsum=mycumsum,idents=idents)

str(fulldat)

myplot <- ggplot(data=fulldat,aes(sorted_lengths,mycumsum,color=factor(idents)))+
    geom_line()+
    geom_point()+
    theme_bw()+
    scale_x_reverse()+
    labs(title=mytitle,x="Sequence length",y="Cumulative Genome Coverage")+
    theme(legend.key.height = unit(1.5, 'cm'))+
    #theme(legend.spacing.y = unit(1.0, 'cm'))+
    scale_color_discrete(name="Assembly")

pdf(outpath,height=4,width=6)
myplot
dev.off()

