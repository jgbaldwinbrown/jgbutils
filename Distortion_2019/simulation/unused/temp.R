#!/usr/bin/env Rscript

data = data.frame(raw=rnorm(n=21000))
data$indivs = factor(ceiling((1:nrow(data) / (nrow(data) / 21))))
data$pos = factor(((1:nrow(data) - 1) %% (nrow(data) / 21)))
data$treat = factor(c(rep(1, nrow(data) / 21), rep(2, nrow(data) / 21 * 20)))
#data$indivs = ceiling((1:nrow(data) / (nrow(data) / 21)))
#data$pos = ((1:nrow(data) - 1) %% (nrow(data) / 21))
#data$treat = c(rep(1, nrow(data) / 21), rep(2, nrow(data) / 21 * 20))

print(head(data))
print(tail(data))
print(str(data))

a = aov(data=data, formula = raw~indivs+Error(pos+treat))
summary(a)
