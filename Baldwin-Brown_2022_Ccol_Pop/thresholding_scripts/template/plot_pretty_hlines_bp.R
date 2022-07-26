#!/usr/bin/env Rscript

library(dplyr)
library(data.table)
library(magrittr)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

giant = as.data.frame(fread(args[1]), header=TRUE)

colnames(giant) = c("chrom", "BP1", "BP", "PFST", "CHISQ", "WINDOW_P", "THRESH", "WINDOW_FDR_P", "WINDOW_FDR_NLOGP", "BONF_THRESH", "CHR", "cumsum.tmp")

## calculating x axis location for chromosome label
med.dat <- giant %>% dplyr::group_by(CHR) %>% dplyr::summarise(median.x = median(cumsum.tmp))

high_thresh = quantile(giant$WINDOW_FDR_NLOGP, .9999, na.rm=TRUE)
print(high_thresh)
giant$pass_high_thresh = giant$WINDOW_FDR_NLOGP > high_thresh
giant$color = factor(((giant$CHR %% 2) * (1-giant$pass_high_thresh)) + (3 * giant$pass_high_thresh))

scale=300
print(head(giant))
png(args[2], width=36*scale, height=4*scale, res=scale)
ggplot(data = giant) +
  geom_point(aes(x = cumsum.tmp, y = -log10(WINDOW_FDR_P), color = color)) +
  geom_hline(yintercept = -log10(0.05), linetype="dashed") +
  geom_hline(yintercept = high_thresh, linetype="dashed") +
  scale_x_continuous(breaks = med.dat$median.x, labels = med.dat$CHR) +
  guides(colour=FALSE) +
  xlab("Chromosome") +
  ylab(expression(-log[10](italic(p)))) +
  scale_color_manual(values = c(gray(0.5), gray(0), "#EE2222"))+
  theme_bw() + 
  theme(text = element_text(size=24))
dev.off()

