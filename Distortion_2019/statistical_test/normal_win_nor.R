#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(argparse))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(zoo))

################################################################################
###functions:

# perform a t-test assuming the first column of a data frame contains the values for one group, and all other columns contain the values for the other group
t_test_cols = function(data){
    return(t.test(data[,ncol(data)], data[,1:(ncol(data) - 1)])$p.value)
}

# the function to do a sliding window t-test for each indiv-chrom-tissue:
chrom_sliding_window = function(sample_chrom_tissue, sample, chrom, tissue, control_tissue, data, win_size, win_step) {
    rows_to_keep1 = (data[,"sample_chrom_tissue"] == sample_chrom_tissue) 
    rows_to_keep2a = (as.character(data[,"chrom"]) == chrom)
    rows_to_keep2b = (as.character(data[,"tissue"]) == control_tissue)
    rows_to_keep2 = rows_to_keep2a & rows_to_keep2b
    rows_to_keep = rows_to_keep1 | rows_to_keep2
    rolldata = data[rows_to_keep,]
    rolldataw = dcast(data = rolldata, formula = pos + chrom ~ sample + indiv + tissue, value.var = "z")
    rollout = rollapply(data=rolldataw[,3:ncol(rolldataw)], width = win_size, by = win_step, by.column = FALSE, FUN = t_test_cols)
    return(rollout)
}

# function to melt data after roll:
meltrolldat = function(rolldat){
    rolldat = as.data.frame(rolldat)
    rolldat$window = 1:nrow(rolldat)
    outdat = melt(rolldat, id.vars="window")
    outsplit = sapply(as.character(outdat$variable), function(x){strsplit(x, "_")})
    indiv = sapply(outsplit, function(x){unlist(x)[1]})
    chrom = sapply(outsplit, function(x){unlist(x)[2]})
    tissue = sapply(outsplit, function(x){unlist(x)[3]})
    out = as.data.frame(cbind(indiv, chrom, tissue, outdat))
    return(out)
}

################################################################################


# create parser object
parser <- ArgumentParser()
parser$add_argument("input", help="Input file.")
parser$add_argument("-o", "--txt_out", default="out.txt", help="Output path for lm-corrected data.")
parser$add_argument("-O", "--txt_out2", default="out2.txt", help="Output path for means of lm-corrected data.")
parser$add_argument("-t", "--txt_out3", default="out3.txt", help="Output path for means of lm-corrected data.")
parser$add_argument("-p", "--pdf_out", default="out.pdf", help="Output file for plot of lm-corrected data.")
parser$add_argument("-P", "--pdf_out2", default="out2.pdf", help="Output file for plot of lm-corrected t-test.")
parser$add_argument("-m", "--pdf_title", default="Chromosome means of deviation from lm", help="Title for pdf.")
parser$add_argument("-M", "--pdf_title2", default="T-test of deviation from lm", help="Title for pdf.")
parser$add_argument("-w", "--win_size", default="1000", help="Size of the sliding window (default = 1000 markers).")
parser$add_argument("-s", "--win_step", default="100", help="Step distance of sliding window (default = 100 markers).")
parser$add_argument("-c", "--control_tissue", default="blood", help="Name of the control tissue (default = blood).")
args <- parser$parse_args()

# capture all arguments in standard variables
input = args$input
txt_out = args$txt_out
txt_out2 = args$txt_out2
txt_out3 = args$txt_out3
pdf_out = args$pdf_out
pdf_title = args$pdf_title
pdf_out2 = args$pdf_out2
pdf_title2 = args$pdf_title2
win_size = floor(as.numeric(args$win_size))
win_step = floor(as.numeric(args$win_step))
control_tissue = args$control_tissue

# read all data into the program
data <- read.table(input)

data$freq = data$hits / data$count

data$pos = factor(data$pos)
data$indiv = factor(data$indiv)
data$sample = factor(data$sample)

data_blood = data[data$tissue=="blood",]

pos_stats = data.frame(pos=levels(factor(data_blood$pos)))
pos_stats$freq_bloodmeans = sapply(levels(factor(data_blood$pos)), function(x){mean(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})
pos_stats$freq_bloodsd = sapply(levels(factor(data_blood$pos)), function(x){sd(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})

data$freq_bloodmean = apply(data, 1, function(x){pos_stats$freq_bloodmeans[pos_stats$pos==x["pos"]]})
data$freq_bloodsd = apply(data, 1, function(x){pos_stats$freq_bloodsd[pos_stats$pos==x["pos"]]})

data$freq_nor = (data$freq - data$freq_bloodmean) / data$freq_bloodsd

# Run the GLM on the data. This GLM estimates hits and counts based on position, gc (continuous), indiv, and tissue
str(data)
l = lm(data, formula = freq_nor ~ sample + tissue)
str(l)
p = predict(l, data) # get a prediction of the value of each real data point based on the model
str(p)

# Add calculated values (p) to the initial data
data$predict = p # values predicted from model
data$diff = data$value - data$predict # difference between actual and predicted value
data$z = scale(data$diff) # same as diff, but subtract mean and divide by sd
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)}) # p value assuming z is normally distributed
data$sample_chrom_tissue = paste(data$sample, data$chrom, data$tissue, sep="_") # aggregate variable that combines individual, chromosome, and tissue -- this combination uniquely describes all GC biases

#head(data)
write.table(data, txt_out)

# Do a sliding window t-test comparing the differences in blood vs. sperm.
# The t-test compares each sample to the collection of all blood samples.
# The Welch's t-test is used so unequal variances and sample sizes are OK.
rolldat = as.data.frame(
    sapply(
        levels(
            factor(data$sample_chrom_tissue)
        ),
        function(x){
            chrom_sliding_window(x,
                data$sample[data$sample_chrom_tissue==x][1],
                data$chrom[data$sample_chrom_tissue==x][1],
                data$tissue[data$sample_chrom_tissue==x][1],
                control_tissue,
                data,
                win_size,
                win_step)
        }
    )
)

rolldatm = meltrolldat(rolldat)

# output
write.table(rolldat, txt_out2)
write.table(rolldatm, txt_out3)

# make a linear plot of the mean amount of difference per chromosome
pdf(pdf_out,height=10,width=3)
ggplot(data=rolldatm, aes(window, value, fill=factor(tissue))) + geom_bar(stat="identity", position="dodge") + facet_grid(indiv~chrom) + ggtitle(pdf_title)
dev.off()

# plot the p-value of the t-test on a -log10 scale
pdf(pdf_out2,height=10,width=3)
ggplot(data=rolldatm, aes(window, -log10(value), fill = factor(tissue))) + geom_bar(stat="identity", position="dodge") + facet_grid(indiv~chrom) + ggtitle(pdf_title2)
dev.off()
