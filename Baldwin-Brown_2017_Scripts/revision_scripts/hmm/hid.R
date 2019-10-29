#!/usr/bin/env Rscript

library(HiddenMarkov)
library(ggplot2)
library(data.table)

get_vhmm_chrom <- function(data) {
    mypi = rbind(c(.001, .001),
        c(.001, .001))
    delta = c(1,0)
    
    if (length(data) > 1) {
        hmm = dthmm(x = data,
            Pi = mypi,
            delta = delta,
            distn = "norm",
            pm = list(mean = c(20, 100), sd = c(20, 100))
        )
        #hmm
        
        vhmm = Viterbi(hmm)
        #vhmm
        return(vhmm)
    } else {
        return(NA)
    }
}

hmm_write_and_plot_xtx_file <- function() {
    args = commandArgs(trailingOnly=TRUE)
    print(args)
    fdata = as.data.frame(fread(args[1], header=TRUE))
    opath = args[2]
    plotpath = args[3]
    hmm_write_and_plot_xtx(fdata, opath, plotpath)
}

hmm_write_and_plot_xtx <- function(fdata, opath, plotpath) {
    hmm_data = hmm_full(fdata)
    write_all(hmm_data, opath)
    plot_all(hmm_data, plotpath)
}

hmm_full <- function(fdata) {
    fdata$vhmm = rep(NA, nrow(fdata))
    data = fdata$xtx
    chroms_uniq = levels(factor(fdata$Chromosome))
    iter = 0
    for (chrom in chroms_uniq) {
        chrom_vhmm = get_vhmm_chrom(data[fdata$Chromosome == chrom])
        chrom_odata = fdata[fdata$Chromosome == chrom, ]
        chrom_odata$vhmm = chrom_vhmm
        if (iter == 0) {
            odata = chrom_odata
        } else {
            odata = as.data.frame(rbind(odata, chrom_odata))
        }
        iter = iter + 1
    }
    return(odata)
}

plot_all <- function(fdata, plotpath) {
    png(plotpath, height = 48*3, width=(640/10)*2*3, res=)
    print(qplot(1:length(fdata$vhmm), fdata$vhmm) + geom_line())
    dev.off()
}

write_all <- function(fdata, opath) {
    write.table(fdata, opath)
}

main <- function() {
    hmm_write_and_plot_xtx_file()
}

main()
