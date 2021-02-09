#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)


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

input = args$input
txt_out = args$txt_out
txt_out2 = args$txt_out2
pdf_out = args$pdf_out
pdf_title = args$pdf_title
pdf_out2 = args$pdf_out2
pdf_title2 = args$pdf_title2

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

l = lm(data, formula = freq_nor ~ sample + tissue)
p = predict(l, data)

data$p = p
data$diff = data$freq_nor - data$p
data$z = scale(data$diff)
temp = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
str(temp)
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
data$indiv_chrom_tissue = paste(data$indiv, data$chrom, data$tissue, sep="_")

head(data)
write.table(data, txt_out)

datameans = aggregate(data$diff, list(data$indiv, data$chrom, data$tissue), mean)
colnames(datameans) = c("indiv", "chrom", "tissue", "x")
datameans$indiv_chrom_tissue = paste(datameans$indiv, datameans$chrom, datameans$tissue, sep="_")
head(datameans)

a = sapply(datameans$indiv_chrom_tissue,
    function(temp){
        t.test(data$diff[data$indiv_chrom_tissue == temp],
            data$diff[data$tissue=="blood"])$p.value
    }
)
datameans$p = a

write.table(datameans, txt_out2)

pdf(pdf_out,height=10,width=3)
ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title)
dev.off()

pdf(pdf_out2,height=10,width=3)
ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2)
dev.off()
