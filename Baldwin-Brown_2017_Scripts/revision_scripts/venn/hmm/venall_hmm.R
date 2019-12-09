#!/usr/bin/env Rscript

library(limma)
library(data.table)

main <- function() {

    fstdata =as.data.frame(fread("../manhat/manhatify_test/testout_manhat_format.txt", header=TRUE))
    fstdata = fstdata[!is.nan(fstdata$P),]
    xtxdata =as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/subsets/manhatify_test/xtxsorted.txt", header=TRUE))
    xtxdata = xtxdata[!is.nan(xtxdata$P),]
    bextxdata =as.data.frame(fread("../manhat/bayenv_xtx/out_manhat_format.txt", header=TRUE))
    bextxdata = bextxdata[!is.nan(bextxdata$P),]
    oldfstdata = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/old_correct_fst/out_manhat_format_nonan.txt", header=TRUE))
    oldfstdata = oldfstdata[!is.nan(oldfstdata$P),]
    bigdata = merge(fstdata, xtxdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    bigdata = merge(bigdata, bextxdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    bigdata = merge(bigdata, oldfstdata, by = c("CHR", "BP"), sort=TRUE, all=TRUE)
    colnames(bigdata) = c("CHR", "BP", "SNP_FST", "FST", "SNP_XTX", "XTX", "SNP_BEXTX", "BEXTX", "SNP_OLDFST", "OLDFST")
    print(head(bigdata))
    write.table(bigdata, "temp.txt")
    venndata = data.frame(
        HC_FST = bigdata$FST > 0.7 & !is.na(bigdata$FST),
        HC_XTX = bigdata$XTX > 30 & !is.na(bigdata$XTX),
        UG_XTX = bigdata$BEXTX > 40 & !is.na(bigdata$BEXTX),
        UG_FST = bigdata$OLDFST > 0.8 & !is.na(bigdata$OLDFST)
    )
    vc = vennCounts(venndata)

    pdf("venn.pdf", width=6, height=6)
    vennDiagram(vc)
    dev.off()
        
    venndata2 = data.frame(
        HC_XTX_SIG = bigdata$XTX > 30 & !is.na(bigdata$XTX),
        HC_XTX = !is.na(bigdata$XTX),
        UG_XTX_SIG = bigdata$BEXTX > 40 & !is.na(bigdata$BEXTX),
        UG_XTX = !is.na(bigdata$BEXTX)
    )
    vc2 = vennCounts(venndata2)

    pdf("venn2.pdf", width=6, height=6)
    vennDiagram(vc2)
    dev.off()
        
}

main()
