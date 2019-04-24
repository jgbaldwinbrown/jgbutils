#!/usr/bin/env Rscript

#test how to use anova in windows:
library(reshape2)
library(zoo)
library(ggplot2)

suppressPackageStartupMessages(library("argparse"))

# create parser object
parser <- ArgumentParser()

# specify our desired options 
parser$add_argument("-e", "--rseed", type="integer", default=0, 
    help="random number generator seed (default=0).")
parser$add_argument("-r", "--reps", type="integer", default=20, 
    help="Number of replicate control individuals (default=20).")
parser$add_argument("-g", "--gensize", type="integer", default=2000, 
    help="Number of heterozygous SNPs in the genome (default=2000).")
parser$add_argument("-t", "--treatsize", type="integer", default=1000, 
    help="Number of heterozygous SNPs in the distorted region (default=1000).")
parser$add_argument("-w", "--winsize", type="integer", default=1001, 
    help="Size of sliding window in number of heterozygous SNPs (default=1001).")
parser$add_argument("-s", "--winstep", type="integer", default=300, 
    help="Step distance of sliding window (default=300).")
parser$add_argument("-b", "--bps_per_hetsnp", type="integer", default=2000, 
    help="Basepairs per heterozygous SNP (default=2000).")
parser$add_argument("-d", "--distortion_frac", type="double", default=0.1, 
    help="Degree of distortion as a fraction of allele frequency(default=0.1).")
parser$add_argument("-o", "--txt_out", default="out.txt", 
    help="Path to text output file (default=out.txt).")
parser$add_argument("-p", "--pdf_out", default="out.pdf", 
    help="Path to pdf output file (default=out.pdf).")
parser$add_argument("-m", "--pdf_title", default="2Mb sliding window ANOVA (simulated)", 
    help="Title of plot.")

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()

rseed = args$rseed
gensize = args$gensize
treatsize = args$treatsize
winsize = args$winsize
winstep = args$winstep
bps_per_hetsnp = args$bps_per_hetsnp
distortion_frac = args$distortion_frac
txt_out = args$txt_out
pdf_out = args$pdf_out
pdf_title = args$pdf_title
reps = args$reps

my_structured_anova <- function(x){
    return(my_anova(structured(x)))
}

structured <- function(x){
    ax <- x[,1]
    a <- data.frame(pos=as.character(1:length(ax)),treat=rep("a",length(ax)),variable=rep("X0",length(ax)),value=ax)
    bx <- x[,2:ncol(x)]
    bd <- data.frame(pos=as.character(1:nrow(bx)),bx,treat=rep("b",nrow(bx)))
    bdm <- melt(bd,id.vars = c("pos","treat"))
    ab <- as.data.frame(rbind(a,bdm))
    #print(head(a))
    #print(head(bd))
    #print(head(bdm))
    return(ab)
}
my_anova <- function(ab){
    return(aov(data=ab,formula=value~variable+pos))
}
#B + (1 | A:B)
my_structured_nested_random_anova <- function(x){
    return(my_anova(structured(x)))
}
my_nested_random_anova <- function(ab){
    return(aov(data=ab,formula=value~variable+pos))
}
my_structured_2random_anova <- function(x){
    return(my_2random_anova(structured(x)))
}
my_2random_anova <- function(ab){
    return(aov(data=ab,formula=value~treat+Error(pos+variable)))
}
my_pval <- function(my_aov){
    return(summary(my_aov)[[2]][[1]]["Pr(>F)"][[1]][1])
}
my_structured_2random_anova_pval <- function(x){
    return(my_pval(my_structured_2random_anova(x)))
}

multitest_2random_anova <- function(x,excols,concols){
    out=rep(NA,length(excols))
    for (i in excols) {
        out[i] <- my_structured_2random_anova_pval(x[,c(excols[i],concols)])
    }
    return(out)
}

roll_multitest <- function(x,excols,concols,size,step){
    my_half <- round((size-1) / 2)
    my_starts <- seq(1,nrow(x)-(size-1),by=step)
    my_ends <- my_starts+(size-1)
    my_mids <- my_starts + my_half
    tempout <- as.data.frame(matrix(ncol=length(excols),nrow=length(my_starts)))
    for (i in 1:nrow(tempout)){
        tempout[i,] <- multitest_2random_anova(x[my_starts[i]:my_ends[i],],excols,concols)
    }
    out <- as.data.frame(cbind(my_starts,my_ends,my_mids,tempout))
    return(out)
}

set.seed(seed = rseed)
means <- rnorm(gensize)
b <- t(sapply(means,function(x){rnorm(reps,mean=x)}))
a1 <- t(sapply(means[1:(gensize - treatsize)],function(x){rnorm(1,mean=x)}))
a2 <- t(sapply(means[(treatsize+1):gensize],function(x){rnorm(1,mean=x+distortion_frac)}))
a <- c(a1,a2)

new2_ab <- cbind(a,b)

#rollmultitemp4 <- roll_multitest(new2_ab,1,2:ncol(new2_ab),100,3)
#plot((1:nrow(rollmultitemp4))*3,-log10(rollmultitemp4$V1),xlab = "Position (simulated)",ylab="-log(p) (simulated)")

rollmultitemp5 <- roll_multitest(new2_ab,1,2:ncol(new2_ab),winsize,winstep)
#about .0005 snps per bp?
#so, 
#ap = ggplot(data=rollmultitemp5,aes(my_mids,V1))+
#    geom_line()
#ap

write.table(rollmultitemp5,txt_out)

ap = ggplot(data=rollmultitemp5,aes(bps_per_hetsnp*my_mids,-log10(V1)))+
    geom_line()+
    theme_bw()+
    labs(x="Genomic position (bp)", y="-log10(p)",title=pdf_title)+
    geom_rect(mapping = aes(xmin=(bps_per_hetsnp * (gensize - treatsize)),xmax=(bps_per_hetsnp * gensize),ymin=0,ymax=6,fill="red"),color="red",alpha=0.002)+
    scale_fill_discrete(name="",breaks=c("red"),labels=c("Allele frequencies distorted"))+
    theme(legend.position="bottom")
ap
pdf(pdf_out,height=3,width=4)
ap
dev.off()

