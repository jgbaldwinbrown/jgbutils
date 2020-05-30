#!/usr/bin/env Rscript

library(HiddenMarkov)
library(ggplot2)
library(data.table)
library(argparse)

parse_all_args <- function() {
    parser <- ArgumentParser()
    parser$add_argument("input", help="Input file.")
    parser$add_argument("-o", "--txt_out", default="out.txt", help="Output path for HMM.")
    parser$add_argument("-p", "--pdf_out", default="out.pdf", help="Output file for HMM plot.")
    parser$add_argument("-c", "--chrom_column", default="CHROM", help="name of column with chromosome names.")
    parser$add_argument("-C", "--chroms", help="Flag to specify presence of chromosome column (must be accompanied by -c).", action="store_true")
    parser$add_argument("-d", "--data_column", default="M_XtX", help="name of column with data to apply HMM to.")
    parser$add_argument("-t", "--trans_prob", default="0.001", help="Transition probability.")
    parser$add_argument("-m", "--mean_background", default="20", help="Mean of background.")
    parser$add_argument("-M", "--mean_peak", default="100", help="Mean inside peak.")
    parser$add_argument("-s", "--sd_background", default="20", help="Standard deviation of background.")
    parser$add_argument("-S", "--sd_peak", default="100", help="Standard deviation inside peak.")
    args = parser$parse_args()
    return(args)
}

get_vhmm_chrom <- function(data, args) {
    print(str(args))
    pival = as.numeric(args$trans_prob)
    print(pival)
    mypi = rbind(c(pival, pival),
        c(pival, pival))
    print(mypi)
    delta = c(1,0)
    
    if (length(data) > 1) {
        mean1 = as.numeric(args$mean_background)
        mean2 = as.numeric(args$mean_peak)
        sd1 = as.numeric(args$sd_background)
        sd2 = as.numeric(args$sd_peak)
        hmm = dthmm(x = data,
            Pi = mypi,
            delta = delta,
            distn = "norm",
            pm = list(mean = c(mean1, mean2), sd = c(sd1, sd2))
        )
        #hmm
        
        str(hmm)
        vhmm = Viterbi(hmm)
        #vhmm
        return(vhmm)
    } else {
        return(NA)
    }
}

hmm_write_and_plot_xtx_file <- function() {
    args = parse_all_args()
    fdata = as.data.frame(fread(args$input, header=TRUE))
    opath = args$txt_out
    plotpath = args$pdf_out
    hmm_write_and_plot_xtx(fdata, opath, plotpath, args)
}

hmm_write_and_plot_xtx <- function(fdata, opath, plotpath, args) {
    hmm_data = hmm_full(fdata, args)
    write_all(hmm_data, opath)
    plot_all(hmm_data, plotpath)
}

hmm_full <- function(fdata, args) {
    if (args$chroms) {
        chromcol = args$chrom_column
        datacol = args$data_column
        fdata$vhmm = rep(NA, nrow(fdata))
        data = fdata[,datacol]
        chroms_uniq = levels(factor(fdata[,chromcol]))
        iter = 0
        for (chrom in chroms_uniq) {
            chrom_vhmm = get_vhmm_chrom(data[fdata[,chromcol] == chrom], args)
            chrom_odata = fdata[fdata[,chromcol] == chrom, ]
            chrom_odata$vhmm = chrom_vhmm
            if (iter == 0) {
                odata = chrom_odata
            } else {
                odata = as.data.frame(rbind(odata, chrom_odata))
            }
            iter = iter + 1
        }
    } else {
        datacol = args$data_column
        fdata$vhmm = rep(NA, nrow(fdata))
        data = fdata[,datacol]
        iter = 0
        vhmm = get_vhmm_chrom(data, args)
        odata = fdata
        odata$vhmm = vhmm
    }
    return(odata)
}

plot_all <- function(fdata, plotpath, args) {
    dpi = 1000
    scale = dpi/72
    png(plotpath, height = 48*3*scale, width=(640/10)*2*3*scale, res=dpi)
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
