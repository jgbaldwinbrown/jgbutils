#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)
library(reshape2)


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

gzcom = paste("gunzip -c ", input, sep="")
data <- as.data.frame(fread(gzcom, header=TRUE, stringsAsFactors=TRUE))

data$pos = factor(data$pos)
data$sample = factor(data$sample)
data$sample = factor(data$sample)

str(data)
l = lm(data, formula = adjusted_value ~ sample + tissue)
p = predict(l, data)

data$p = p
data$diff = data$adjusted_value - data$p
data$z = scale(data$diff)
temp = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
str(temp)
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
data$sample_chrom_tissue = paste(data$sample, data$chrom, data$tissue, sep="_")

head(data)
write.table(data, txt_out)

datameans = aggregate(data$diff, list(data$sample, data$chrom, data$tissue), mean)
colnames(datameans) = c("sample", "chrom", "tissue", "x")
datameans$sample_chrom_tissue = paste(datameans$sample, datameans$chrom, datameans$tissue, sep="_")
head(datameans)

a = sapply(datameans$sample_chrom_tissue,
    function(temp){
        seta = data$sample_chrom_tissue == temp
        setb = data$tissue == "Blood"
        groupa = data$diff[seta]
        groupb = data$diff[setb]
        print("groupa sum")
        print(head(groupa))
        print(head(groupb))
        print(sum(! is.na(groupa)) >= 1)
        # print(sum(!is.na(groupa)) >= 2 & sum(! is.na(groupb)) >= 2)
        if (
            sum(!is.na(groupa)) >= 1 &
            sum(!is.na(groupb)) >= 1
        ) {
            print("seta")
            print(head(data$diff[seta]))
            print("setb")
            print(head(data$diff[setb]))
            return(
                t.test(data$diff[seta],
                    data$diff[setb])$p.value
            )
        } else {
            return(NA)
        }
    }
)
datameans$p = a

write.table(datameans, txt_out2)

pdf(pdf_out,height=10,width=3)
ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(sample~tissue) + ggtitle(pdf_title)
dev.off()

pdf(pdf_out2,height=10,width=3)
ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(sample~tissue) + ggtitle(pdf_title2)
dev.off()
