#!/usr/bin/env Rscript

#test how to use anova in windows:
suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("reshape2"))
suppressPackageStartupMessages(library("zoo"))
suppressPackageStartupMessages(library("ggplot2"))

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
parser$add_argument("-O", "--simulation_data_out", default="out_sim.txt", 
    help="Path to simulation data output file (default=out_sim.txt).")
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
txt_sim_out = args$simulation_data_out
pdf_out = args$pdf_out
pdf_title = args$pdf_title
reps = args$reps

structured <- function(x){
    #print(paste("structured starting:", Sys.time()))
    ax <- x[,1]
    a <- data.frame(pos=as.character(1:length(ax)),treat=rep("a",length(ax)),variable=rep("X0",length(ax)),value=ax)
    bx <- x[,2:ncol(x)]
    bd <- data.frame(pos=as.character(1:nrow(bx)),bx,treat=rep("b",nrow(bx)))
    bdm <- melt(bd,id.vars = c("pos","treat"))
    ab <- as.data.frame(rbind(a,bdm))
    ab$pos = as.numeric(ab$pos)
    ab$treat = as.numeric(ab$treat)
    ab$variable = as.numeric(ab$variable)
    #print(head(a))
    #print(head(bd))
    #print(head(bdm))
    #print(head(ab))
    #print(str(ab))
    #print(paste("structured done:", Sys.time()))
    return(ab)
}

my_treat_anova <- function(ab){
    #print(paste("anova starting:", Sys.time()))
    out = aov(data=ab,formula=value~treat+variable+pos)
    #print(paste("anova done:", Sys.time()))
    return(out)
}
my_pval_treat <- function(my_aov){
    #print(paste("pval starting:", Sys.time()))
    #print(summary(my_aov))
    #str(summary(my_aov))
    out = summary(my_aov)[[1]]["Pr(>F)"][1]
    #print(paste("pval done:", Sys.time()))
    return(out)
}
my_structured_treat_anova_pval <- function(x){
    #print(paste("structured_treat_anova_pval starting:", Sys.time()))
    out = my_pval_treat(my_treat_anova(structured(x)))
    #print(paste("structured_treat_anova_pval done:", Sys.time()))
    return(out)
}
multitest_treat_anova <- function(x,excols,concols){
    #print(paste("multitest starting:", Sys.time()))
    out=rep(NA,length(excols))
    for (i in excols) {
        #print(paste("multitest loop starting:", Sys.time()))
        out[i] <- my_structured_treat_anova_pval(x[,c(excols[i],concols)])
        #print(paste("multitest loop done:", Sys.time()))
    }
    #print(paste("multitest done:", Sys.time()))
    return(out)
}
roll_multitest_treat <- function(x,excols,concols,size,step){
    my_half <- round((size-1) / 2)
    my_starts <- seq(1,nrow(x)-(size-1),by=step)
    my_ends <- my_starts+(size-1)
    my_mids <- my_starts + my_half
    tempout <- as.data.frame(matrix(ncol=length(excols),nrow=length(my_starts)))
    for (i in 1:nrow(tempout)){
        tempout[i,] <- multitest_treat_anova(x[my_starts[i]:my_ends[i],],excols,concols)
    }
    out <- as.data.frame(cbind(my_starts,my_ends,my_mids,tempout))
    #print(paste("roll_multi done:", Sys.time()))
    return(out)
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
write.table(new2_ab, txt_sim_out)

rollmultitemp5 <- roll_multitest_treat(new2_ab,1,2:ncol(new2_ab),winsize,winstep)

write.table(rollmultitemp5,txt_out)

ap = ggplot(data=rollmultitemp5,aes(bps_per_hetsnp*my_mids,-log10(V1)))+
    geom_line()+
    theme_bw()+
    labs(x="Genomic position (bp)", y="-log10(p)",title=pdf_title)+
    geom_rect(mapping = aes(xmin=(bps_per_hetsnp * (gensize - treatsize)),xmax=(bps_per_hetsnp * gensize),ymin=0,ymax=6,fill="red"),color="red",alpha=0.002)+
    scale_fill_discrete(name="",breaks=c("red"),labels=c("Allele frequencies distorted"))+
    theme(legend.position="bottom")

pdf(pdf_out,height=3,width=4)
ap
dev.off()

