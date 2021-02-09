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

# set random seed
set.seed(seed = rseed)

# generate mean for each locus
means <- rnorm(gensize)

# generate a set of identical sperm samples
b <- t(sapply(means, function(x){rep(x, reps)}))
# generate a set of identical blood samples
a <- t(sapply(means, function(x){rep(x, reps)}))

colnames(a) = 1:ncol(a)
colnames(b) = 1:ncol(b)

# melt sperm and blood samples, name them
a=melt(a)
a$tissue = rep("sperm", nrow(a))
b=melt(b)
b$tissue = rep("blood", nrow(b))

# combine blood and sperm samples
new2_ab = as.data.frame(rbind(a,b))

# specify chromosomes for all samples
new2_ab$chrom = rep(
    rep(
        seq(1,nchroms),
        each=gensize / nchroms
    ),
    nrow(new2_ab) / gensize
)

# generate per-chromosome gc bias values, add to data
gcs = rnorm(n=nchroms)
new2_ab$gc = sapply(new2_ab$chrom, function(x){gcs[x]})

# make sure chroms are factors
new2_ab$chrom = factor(new2_ab$chrom)

# assign a unique sample number to each sample
new2_ab$sample = rep(seq(1,nrow(new2_ab) / gensize), each = gensize)

# name pos and indiv columns correctly
colnames(new2_ab)[1] = "pos"
colnames(new2_ab)[2] = "indiv"

# generate and apply sample biases
biases = 0.5 + rnorm(n=length(levels(factor(new2_ab$sample))), sd=0.1)
new2_ab$bias = sapply(new2_ab$sample, function(x){biases[x]})

# generate and apply sample-specific, gc-specific bias
new2_ab$sample_gc = 0.5 + rnorm(n=length(levels(factor(new2_ab$sample))), sd=0.1)
new2_ab$sample_gc_bias = new2_ab$sample_gc * new2_ab$gc

# generate coverage counts at each locus, with bias based on sample
new2_ab$count = rpois(nrow(new2_ab), (rep(avgcov, nrow(new2_ab)) + new2_ab$bias + new2_ab$sample_gc_bias))

# generate allele counts based on binomial draws from coverage
new2_ab$hits = rbinom(nrow(new2_ab), new2_ab$count, new2_ab$bias)

# make sure 1 region of the genome is selected, and give it a bias toward 1 allele
# this region of the genome should be found in only 1 chromosome of 1 individual
selectedstart = (gensize-treatsize) + 1
selectedend = gensize
selectedrange = selectedstart:selectedend
new2_ab$hits[selectedrange] = rbinom((selectedend - selectedstart) + 1, new2_ab$count[selectedrange], new2_ab$bias[selectedrange] + distortion_frac)

write.table(new2_ab, txt_sim_out)

