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
parser$add_argument("-R", "--sperm_reps", type="integer", default=20, 
    help="Number of replicate sperm samples (default=20).")
parser$add_argument("-g", "--gensize", type="integer", default=2000, 
    help="Number of heterozygous SNPs in the genome (default=2000).")
parser$add_argument("-t", "--treatsize", type="integer", default=1000, 
    help="Number of heterozygous SNPs in the distorted region (default=1000).")
parser$add_argument("-c", "--chroms", type="integer", default=4, 
    help="Number of chromosomes per genome(default=4).")
parser$add_argument("-b", "--bps_per_hetsnp", type="integer", default=2000, 
    help="Basepairs per heterozygous SNP (default=2000).")
parser$add_argument("-d", "--distortion_frac", type="double", default=0.1, 
    help="Degree of distortion as a fraction of allele frequency(default=0.1).")
parser$add_argument("-a", "--average_coverage", type="double", default=1.75, 
    help="Average genome coverage (default=1.75).")
parser$add_argument("-O", "--simulation_data_out", default="out_sim.txt", 
    help="Path to simulation data output file (default=out_sim.txt).")
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
txt_sim_out = args$simulation_data_out
pdf_out = args$pdf_out
pdf_title = args$pdf_title
reps = args$reps
sperm_reps = args$sperm_reps
nchroms = args$chroms
avgcov = args$average_coverage

set.seed(seed = rseed)

means <- rnorm(gensize)
b <- t(sapply(means, function(x){rep(x, reps)}))
a <- t(sapply(means, function(x){rep(x, reps)}))

colnames(a) = 1:ncol(a)
colnames(b) = 1:ncol(b)

a=melt(a)
a$tissue = rep("sperm", nrow(a))
b=melt(b)
b$tissue = rep("blood", nrow(b))

new2_ab = as.data.frame(rbind(a,b))
new2_ab$chrom = rep(
    rep(
        seq(1,nchroms),
        each=gensize / nchroms
    ),
    nrow(new2_ab) / gensize
)
gcs = rnorm(n=nchroms)
new2_ab$gc = sapply(new2_ab$chrom, function(x){gcs[x]})
new2_ab$chrom = factor(new2_ab$chrom)
new2_ab$sample = rep(seq(1,nrow(new2_ab) / gensize), each = gensize)
colnames(new2_ab)[1] = "pos"
colnames(new2_ab)[2] = "indiv"
biases = 0.5 + rnorm(n=length(levels(factor(new2_ab$sample))), sd=0.1)
new2_ab$bias = sapply(new2_ab$sample, function(x){biases[x]})
new2_ab$count = rpois(nrow(new2_ab), (rep(avgcov, nrow(new2_ab)) + new2_ab$bias))
new2_ab$hits = rbinom(nrow(new2_ab), new2_ab$count, new2_ab$bias)
selectedstart = (gensize-treatsize) + 1
selectedend = gensize
selectedrange = selectedstart:selectedend
new2_ab$hits[selectedrange] = rbinom((selectedend - selectedstart) + 1, new2_ab$count[selectedrange], new2_ab$bias[selectedrange] + distortion_frac)

write.table(new2_ab, txt_sim_out)

