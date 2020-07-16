#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(argparse))
suppressPackageStartupMessages(library(ggplot2))


# create parser object
parser <- ArgumentParser()
parser$add_argument("input", help="Input file.")
parser$add_argument("-o", "--txt_out", default="out.txt", help="Output path for lm-corrected data.")
parser$add_argument("-O", "--txt_out2", default="out2.txt", help="Output path for means of lm-corrected data.")
parser$add_argument("-p", "--pdf_out", default="out.pdf", help="Output file for plot of lm-corrected data.")
parser$add_argument("-P", "--pdf_out2", default="out2.pdf", help="Output file for plot of lm-corrected t-test.")
parser$add_argument("-m", "--pdf_title", default="Chromosome means of deviation from lm", help="Title for pdf.")
parser$add_argument("-M", "--pdf_title2", default="T-test of deviation from lm", help="Title for pdf.")
args <- parser$parse_args()

# capture all arguments in standard variables
input = args$input
txt_out = args$txt_out
txt_out2 = args$txt_out2
pdf_out = args$pdf_out
pdf_title = args$pdf_title
pdf_out2 = args$pdf_out2
pdf_title2 = args$pdf_title2

# read all data into the program
data <- read.table(input)

# Run the GLM on the data. This GLM estimates hits and counts based on position, gc (continuous), indiv, and tissue
l = glm(data, formula = cbind(hits, count) ~ pos + gc*indiv*tissue, family="binomial")
p = predict(l, data) # get a prediction of the value of each real data point based on the model

# Add calculated values (p) to the initial data
data$predict = p # values predicted from model
data$diff = data$value - data$predict # difference between actual and predicted value
data$z = scale(data$diff) # same as diff, but subtract mean and divide by sd
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)}) # p value assuming z is normally distributed
data$indiv_chrom_tissue = paste(data$indiv, data$chrom, data$tissue, sep="_") # aggregate variable that combines individual, chromosome, and tissue -- this combination uniquely describes all GC biases

write.table(data, txt_out)

# get per-chromosome means of the differences
datameans = aggregate(data$diff, list(data$indiv, data$chrom, data$tissue), mean)
colnames(datameans) = c("indiv", "chrom", "tissue", "x")
datameans$indiv_chrom_tissue = paste(datameans$indiv, datameans$chrom, datameans$tissue, sep="_")

# Do a t-test comparing the differences in blood vs. sperm.
# The t-test compares each sample to the collection of all blood samples.
# The Welch's t-test is used so unequal variances and sample sizes are OK.
a = sapply(datameans$indiv_chrom_tissue,
    function(temp){
        t.test(data$diff[data$indiv_chrom_tissue == temp],
            data$diff[data$tissue=="blood"])$p.value }
)
datameans$p = a # save the p-values of the t-tests in datameans.

# output
write.table(datameans, txt_out2)

# make a linear plot of the mean amount of difference per chromosome
pdf(pdf_out,height=10,width=3)
#qqnorm(data$diff[data$indiv == 1 & data$tissue=="sperm"])
#qqline(data$diff)
ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title)
dev.off()

# plot the p-value of the t-test on a -log10 scale
pdf(pdf_out2,height=10,width=3)
#qqnorm(data$diff[data$indiv == 1 & data$tissue=="sperm"])
#qqline(data$diff)
ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2)
dev.off()
