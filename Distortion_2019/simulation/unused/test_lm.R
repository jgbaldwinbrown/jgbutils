#!/usr/bin/env Rscript

library(ggplot2)

data <- read.table("out_sim.txt")
head(data)
str(data)

l = lm(data, formula = value ~ pos + indiv + tissue + gc*sample + sample)
p = predict(l, data)
print(summary(l))
print(l$sigma)

str(p)

data$p = p
data$diff = data$value - data$p

head(data)

datameans = aggregate(data$diff, list(data$sample, data$chrom), mean)

pdf("temp.pdf",height=4,width=3)
#qqnorm(data$diff[data$indiv == 1 & data$tissue=="sperm"])
#qqline(data$diff)
ggplot(data=datameans, aes(Group.2, x)) + geom_bar(stat="identity") + facet_wrap(~Group.1)
dev.off()
