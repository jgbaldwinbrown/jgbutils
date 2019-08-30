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
head("data")
head(data)
str("data")
str(data)
data$freq = data$hits / data$count

print("start glm")
l = lm(data, formula = freq ~ pos + gc*indiv*tissue)
print("did glm")
p = predict(l, data)
print("summary(l)")
print(summary(l))
print("l$sigma")
print(l$sigma)

print("p")
str(p)

print("1")
data$p = p
print("2")
data$diff = data$value - data$p
print("3")
data$z = scale(data$diff)
print("4")
print("str(data)")
str(data)
temp = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
print("str(temp)")
str(temp)
data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
print("1")
data$indiv_chrom_tissue = paste(data$indiv, data$chrom, data$tissue, sep="_")
print("6")

print("data")
head(data)
write.table(data, txt_out)

datameans = aggregate(data$diff, list(data$indiv, data$chrom, data$tissue), mean)
colnames(datameans) = c("indiv", "chrom", "tissue", "x")
datameans$indiv_chrom_tissue = paste(datameans$indiv, datameans$chrom, datameans$tissue, sep="_")
print("datameans")
head(datameans)

a = sapply(datameans$indiv_chrom_tissue,
    function(temp){
        t.test(data$diff[data$indiv_chrom_tissue == temp],
            data$diff[data$tissue=="blood"])$p.value
    }
)
print("a")
str(a)
print("datameans")
str(datameans)
datameans$p = a

write.table(datameans, txt_out2)

pdf(pdf_out,height=10,width=3)
#qqnorm(data$diff[data$indiv == 1 & data$tissue=="sperm"])
#qqline(data$diff)
ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title)
dev.off()

pdf(pdf_out2,height=10,width=3)
#qqnorm(data$diff[data$indiv == 1 & data$tissue=="sperm"])
#qqline(data$diff)
ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2)
dev.off()
