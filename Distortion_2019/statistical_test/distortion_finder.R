#!/usr/bin/env Rscript

library(ggplot2)
library(argparse)
library(data.table)
suppressMessages(library(utils))
suppressMessages(library(backports))
suppressMessages(library(data.table))
deparse1 = getFromNamespace("deparse1", "backports")
suppressMessages(library(typed))
options(error = quote({dump.frames(to.file=TRUE); q()}))

# subset_mean <- function(dat,x) {
# 	mean(dat$freq[dat$pos==x], na.rm=TRUE)
# }
# 
# subset_sd <- function(dat, x) {
# 	sd(dat$freq[dat$pos==x], na.rm=TRUE)
# }

main <- function() {
    args = get_args()
    if (args$test == "freq_f") {
        run_freq_f(args)
    } else if (args$test == "freq_f_ill") {
        run_freq_f_ill(args)
    } else if (args$test == "coverage_t") {
        run_coverage_t(args)
    } else if (args$test == "coverage_t_cov") {
        run_coverage_t_cov(args)
    } else if (args$test == "coverage_t_ill") {
        run_coverage_t_ill(args)
    } else if (args$test == "coverage_t_cov_ill") {
        run_coverage_t_cov_ill(args)
    } else {
        exit("This test does not exist!")
    }
}
get_args <- function() {
    parser <- ArgumentParser()
    parser$add_argument("input", help="Input file.")
    parser$add_argument("-o", "--txt_out", default="out.txt", help="Output path for lm-corrected data.")
    parser$add_argument("-O", "--txt_out2", default="out2.txt", help="Output path for means of lm-corrected data.")
    parser$add_argument("-p", "--pdf_out", default="out.pdf", help="Output file for plot of lm-corrected data.")
    parser$add_argument("-P", "--pdf_out2", default="out2.pdf", help="Output file for plot of lm-corrected t-test.")
    parser$add_argument("-F", "--pdf_out3", default="out3.pdf", help="Output file for plot of lm-corrected t-test (fdr-corrected).")
    parser$add_argument("-m", "--pdf_title", default="Chromosome means of deviation from lm", help="Title for pdf.")
    parser$add_argument("-M", "--pdf_title2", default="T-test of deviation from lm", help="Title for pdf.")
    parser$add_argument("-N", "--pdf_title3", default="T-test of deviation from lm (FDR-corrected)", help="Title for pdf.")
    parser$add_argument("-t", "--test", default="freq_f", help="Statistical test to perform (options are freq_f, freq_f_ill, coverage_t, coverage_t_cov, coverage_t_ill, coverage_t_cov_ill)")
    parser$add_argument("-r", "--rename", default=FALSE, help="Rename columns to match standard", action="store_true")
    args <- parser$parse_args()
    return(args)
}

rename_data <- Data.frame() ? function(data= ? Data.frame()) {
    Character() ? n
    n <- names(data)
    n[n=="Chromosome"] <- "chrom"
    n[n=="Position"] <- "pos"
    n[n=="Indivs"] <- "indiv"
    n[n=="unique_id"] <- "sample"
    names(data) <- n
    return(data)
}

run_freq_f <- function(args) {
    input = args$input
    txt_out = args$txt_out
    txt_out2 = args$txt_out2
    pdf_out = args$pdf_out
    pdf_title = args$pdf_title
    pdf_out2 = args$pdf_out2
    pdf_title2 = args$pdf_title2
    pdf_out3 = args$pdf_out3
    pdf_title3 = args$pdf_title3
    # data <- read.table(input)
    data <- as.data.frame(fread(input))
    if (args$rename) {
        data <-rename_data(data)
        data$freq <- data$value
        # data$freq = data$afrac
    } else {
        data$freq <- data$hits / data$count
    }

    data$pos = factor(data$pos)
    data$indiv = factor(data$indiv)
    data$sample = factor(data$sample)

    data_blood = data[data$tissue=="blood",]

    pos_stats = data.frame(pos=levels(factor(data_blood$pos)))
    pos_stats$freq_bloodmeans = sapply(levels(factor(data_blood$pos)), function(x){mean(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})
    pos_stats$freq_bloodsd = sapply(levels(factor(data_blood$pos)), function(x){sd(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})

    data$bloodmean = apply(data, 1, function(x){pos_stats$freq_bloodmeans[pos_stats$pos==x["pos"]]})
    data$bloodsd = apply(data, 1, function(x){pos_stats$freq_bloodsd[pos_stats$pos==x["pos"]]})

    data$freq_nor = (data$freq - data$bloodmean) / data$bloodsd

    print(data)
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
            var.test(data$diff[data$indiv_chrom_tissue == temp],
                data$diff[data$tissue=="blood"])$p.value
        }
    )
    datameans$p = a

    plot_nrows = length(levels(factor(datameans$indiv)))

    pdf(pdf_out,height=1 * plot_nrows,width=3)
    ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title)
    dev.off()

    pdf(pdf_out2,height=1 * plot_nrows,width=3)
    ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2)
    dev.off()
}

run_freq_f_ill <- function(args) {
}

run_coverage_t <- function(args) {
    args <- parser$parse_args()
    
    input = args$input
    txt_out = args$txt_out
    txt_out2 = args$txt_out2
    pdf_out = args$pdf_out
    pdf_title = args$pdf_title
    pdf_out2 = args$pdf_out2
    pdf_title2 = args$pdf_title2
    
    # data <- read.table(input)
    data <- as.data.frame(fread(input))
    if (args$rename) {
        data <-rename_data(data)
        data$freq = data$value
        # data$freq = data$afrac
    } else {
        data$freq = data$count
    }
    # data$freq = data$hits / data$count
    
    data$pos = factor(data$pos)
    data$indiv = factor(data$indiv)
    data$sample = factor(data$sample)
    
    data_blood = data[data$tissue=="blood",]
    
    pos_stats = data.frame(pos=levels(factor(data_blood$pos)))
    pos_stats$freq_bloodmeans = sapply(levels(factor(data_blood$pos)), function(x){mean(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})
    pos_stats$freq_bloodsd = sapply(levels(factor(data_blood$pos)), function(x){sd(data_blood$freq[data_blood$pos==x], na.rm=TRUE)})
    
    data$bloodmean = apply(data, 1, function(x){pos_stats$freq_bloodmeans[pos_stats$pos==x["pos"]]})
    data$bloodsd = apply(data, 1, function(x){pos_stats$freq_bloodsd[pos_stats$pos==x["pos"]]})
    
    data$freq_nor = (data$freq - data$bloodmean) / data$bloodsd
    
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
    
    plot_nrows = length(levels(factor(datameans$indiv)))
    
    pdf(pdf_out,height=1 * plot_nrows,width=3)
    ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title)
    dev.off()
    
    pdf(pdf_out2,height=1 * plot_nrows,width=3)
    ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2)
    dev.off()
}

run_coverage_t_cov <- function(args) {
    input = args$input
    txt_out = args$txt_out
    txt_out2 = args$txt_out2
    pdf_out = args$pdf_out
    pdf_title = args$pdf_title
    pdf_out2 = args$pdf_out2
    pdf_title2 = args$pdf_title2
    pdf_out3 = args$pdf_out3
    pdf_title3 = args$pdf_title3
    
    # data <- read.table(input)
    data <- as.data.frame(fread(input))
    if (args$rename) {
        data <-rename_data(data)
        data$freq = data$value
        # data$freq = data$afrac
    } else {
        data$freq = data$count
    }
    
    data$pos = factor(data$pos)
    data$indiv = factor(data$indiv)
    data$sample = factor(data$sample)
    
    data_blood = data[data$tissue=="blood",]

    print(1)
    
    # pos_stats = data.frame(pos=levels(factor(data_blood$pos)))
    # pos_stats$freq_bloodmeans = sapply(
    #     levels(factor(data_blood$pos)), 
    #     function(x) {
    #         mean(data_blood$freq[data_blood$pos==x], na.rm=TRUE)
    #     }
    # )
    # pos_stats$freq_bloodsd = sapply(
    #     levels(factor(data_blood$pos)),
    #     function(x) {
    #         sd(data_blood$freq[data_blood$pos==x], na.rm=TRUE)
    #     }
    # )

    print(2)
    
    # data$freq_bloodmean = apply(data, 1, function(x){pos_stats$freq_bloodmeans[pos_stats$pos==x["pos"]]})
    # print(3)
    # data$freq_bloodsd = apply(data, 1, function(x){pos_stats$freq_bloodsd[pos_stats$pos==x["pos"]]})
    # print(4)
    
    data$freq_nor = (data$freq - data$bloodmean) / data$bloodsd
    print(5)
    
    data = data[!is.nan(data$freq_nor) & !is.na(data$freq_nor) & !is.infinite(data$freq_nor),]
    l = lm(data, formula = freq_nor ~ per_chrom_gc_index + sample + tissue)
    print(5)
    p = predict(l, data)
    print(6)
    
    data$p = p
    print(7)
    data$diff = data$freq_nor - data$p
    print(8)
    data$z = scale(data$diff)
    print(9)
    temp = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
    print(10)
    str(temp)
    print(11)
    data$p = sapply(data$z, function(x){pnorm(-abs(x), mean=0, sd=1, lower.tail=TRUE)})
    print(12)
    data$indiv_chrom_tissue = paste(data$indiv, data$chrom, data$tissue, sep="_")
    print(13)
    
    head(data)
    write.table(data, txt_out)
    
    print(14)
    datameans = aggregate(data$diff, list(data$indiv, data$chrom, data$tissue), mean)
    colnames(datameans) = c("indiv", "chrom", "tissue", "x")
    datameans$indiv_chrom_tissue = paste(datameans$indiv, datameans$chrom, datameans$tissue, sep="_")
    head(datameans)
    print(15)
    
    a = sapply(datameans$indiv_chrom_tissue,
        function(temp){
            t.test(data$diff[data$indiv_chrom_tissue == temp],
                data$diff[data$tissue=="blood"])$p.value
        }
    )
    datameans$p = a
    
    print(16)
    write.table(datameans, txt_out2)
    
    print(17)
    pdf(pdf_out,height=10,width=3)
    print(ggplot(data=datameans, aes(chrom, x)) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title))
    dev.off()
    
    print(18)
    pdf(pdf_out2,height=10,width=3)
    print(ggplot(data=datameans, aes(chrom, -log10(p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title2))
    dev.off()

    datameans$fdr_p = p.adjust(datameans$p, method = "BH")
    
    print(19)
    pdf(pdf_out3,height=10,width=3)
    print(ggplot(data=datameans, aes(chrom, -log10(fdr_p))) + geom_bar(stat="identity") + facet_grid(indiv~tissue) + ggtitle(pdf_title3))
    dev.off()
}

run_coverage_t_ill <- function(args) {
}

run_coverage_t_cov_ill <- function(args) {
}

main()
