#!/usr/bin/env Rscript
print(1)

print(2)
library(ggplot2)
print(3)
library(argparse)
print(4)
library(data.table)
print(4.1)
library(reshape2)
print(4.2)

print(5)

print(6)
# create parser object
print(7)
parser <- ArgumentParser()
print(8)
parser$add_argument("input", help="Input file.")
print(9)
parser$add_argument("-o", "--txt_out", default="out.txt", help="Output path for lm-corrected data.")
print(10)
parser$add_argument("-O", "--txt_out2", default="out2.txt", help="Output path for means of lm-corrected data.")
print(11)
parser$add_argument("-p", "--pdf_out", default="out.pdf", help="Output file for plot of lm-corrected data.")
print(12)
parser$add_argument("-P", "--pdf_out2", default="out2.pdf", help="Output file for plot of lm-corrected t-test.")
print(13)
parser$add_argument("-m", "--pdf_title", default="Chromosome means of deviation from lm", help="Title for pdf.")
print(14)
parser$add_argument("-M", "--pdf_title2", default="T-test of deviation from lm", help="Title for pdf.")
print(15)
args <- parser$parse_args()
print(16)

print(17)
input = args$input
print(18)
txt_out = args$txt_out
print(19)
txt_out2 = args$txt_out2
print(20)
pdf_out = args$pdf_out
print(21)
pdf_title = args$pdf_title
print(22)
pdf_out2 = args$pdf_out2
print(23)
pdf_title2 = args$pdf_title2
print(24)

print(25)
gzcom = paste("gunzip -c ", input, sep="")
data <- as.data.frame(fread(gzcom, header=TRUE, stringsAsFactors=TRUE))
print(26)
str(data)
data$freq = data$hits / data$count
print(27)

print(28)
data$pos = factor(data$pos)
print(29)
data$sample = factor(data$sample)
print(30)
data$sample = factor(data$sample)
print(31)

str(data)
print(32)
l = lm(data, formula = freq_nor_het_blood ~ sample + tissue)
print(44)
p = predict(l, data)
print(45)

print(46)
data$p = p
print(47)
data$diff = data$freq_nor - data$p
print(48)
data$z = scale(data$diff)
print(49)
temp = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
print(50)
str(temp)
print(51)
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
print(52)
data$sample_chrom_tissue = paste(data$sample, data$chrom, data$tissue, sep="_")
print(53)

print(54)
head(data)
print(55)
write.table(data, txt_out)
print(56)

print(57)
datameans = aggregate(data$diff, list(data$sample, data$chrom, data$tissue), mean)
print(58)
colnames(datameans) = c("sample", "chrom", "tissue", "x")
print(59)
datameans$sample_chrom_tissue = paste(datameans$sample, datameans$chrom, datameans$tissue, sep="_")
print(60)
head(datameans)
print(61)

print(62)
a = sapply(datameans$sample_chrom_tissue,
    function(temp){
        t.test(data$diff[data$sample_chrom_tissue == temp],
            data$diff[data$tissue=="Blood"])$p.value
    }
)
print(68)
datameans$p = a
print(69)

print(70)
write.table(datameans, txt_out2)
print(71)

print(72)
pdf(pdf_out,height=10,width=3)
print(73)
ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(sample~tissue) + ggtitle(pdf_title)
print(74)
dev.off()
print(75)

print(76)
pdf(pdf_out2,height=10,width=3)
print(77)
ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(sample~tissue) + ggtitle(pdf_title2)
print(78)
dev.off()
print(79)
