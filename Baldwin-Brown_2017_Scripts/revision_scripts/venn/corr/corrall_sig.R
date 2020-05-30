#!/usr/bin/env Rscript

library(limma)
library(data.table)

main <- function() {

    fstdata =as.data.frame(fread("../../manhat/manhatify_test/testout_manhat_format.txt", header=TRUE))
    fstdata = fstdata[!is.nan(fstdata$P),]
    xtxdata =as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/subsets/manhatify_test/xtxsorted.txt", header=TRUE))
    xtxdata = xtxdata[!is.nan(xtxdata$P),]
    bextxdata =as.data.frame(fread("../../manhat/bayenv_xtx/out_manhat_format.txt", header=TRUE))
    bextxdata = bextxdata[!is.nan(bextxdata$P),]
    oldfstdata = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/old_correct_fst/out_manhat_format_nonan.txt", header=TRUE))
    oldfstdata = oldfstdata[!is.nan(oldfstdata$P),]
    bigdata = merge(fstdata, xtxdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    bigdata = merge(bigdata, bextxdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    bigdata = merge(bigdata, oldfstdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    bigdata2 = bigdata[complete.cases(bigdata),]
    colnames(bigdata) = c("CHR", "BP", "SNP_FST", "FST", "SNP_XTX", "XTX", "SNP_BEXTX", "BEXTX", "SNP_OLDFST", "OLDFST")
    colnames(bigdata2) = c("CHR", "BP", "SNP_FST", "FST", "SNP_XTX", "XTX", "SNP_BEXTX", "BEXTX", "SNP_OLDFST", "OLDFST")
    bigdata2_sig = bigdata2[
        (bigdata2$FST > 0.7 & !is.na(bigdata2$FST)) |
        (bigdata2$XTX > 30 & !is.na(bigdata2$XTX)) |
        (bigdata2$BEXTX > 40 & !is.na(bigdata2$BEXTX)) |
        (bigdata2$OLDFST > 0.8 & !is.na(bigdata2$OLDFST))
        ,
    ]
    bigdata2_sig_mini = bigdata2_sig[,c("FST", "XTX", "BEXTX", "OLDFST")]
    corr = cor(bigdata2_sig)
    corr_mini = cor(bigdata2_sig_mini)
    write.table(bigdata2_sig, "bigdata2_sig.txt", quote=FALSE, sep="\t")
    write.table(corr, "corr_sig.txt", quote=FALSE, sep="\t")
    write.table(corr_mini, "corr_mini_sig.txt", quote=FALSE, sep="\t")
}

main()
