#!/usr/bin/env Rscript

library(limma)
library(data.table)

main <- function() {

    old_data = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/full_run/data/snpbeds/all_beds/old_correct/uncens_bedified_snpsfile_correct.bed"))
    print(head(old_data))
    hc200_data = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/full_run/data/snpbeds/all_beds/haplocaller_200ploid/degs.input.bedified.bed.count"))
    sam_data = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/full_run/data/snpbeds/all_beds/samtools_popoolation/degs.input.bedified.bed.count"))
    hc2_data = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/full_run/data/snpbeds/all_beds/haplocaller_2ploid/degs.input.bedified.bed.count"))
    m_old_data = melt(old_data, id.vars=c("V1", "V2", "V3"))
    rm(old_data)
    m_hc200_data = melt(hc200_data, id.vars=c("V1", "V2", "V3"))
    rm(hc200_data)
    m_hc2_data = melt(hc2_data, id.vars=c("V1", "V2", "V3"))
    rm(hc2_data)
    print("pre-melt sam")
    m_sam_data = melt(sam_data, id.vars=c("V1", "V2", "V3"))
    print("melted sam")
    rm(sam_data)
    print("pre-merge")
    bigdata = merge(m_old_data, m_hc200_data, by=c("V1", "V2", "V3", "variable"))
    print("merging 1")
    rm(m_old_data, m_hc200_data)
    bigdata = merge(bigdata, m_sam_data, by=c("V1", "V2", "V3", "variable"))
    print("merging 2")
    rm(m_sam_data)
    bigdata = merge(bigdata, m_hc2_data, by=c("V1", "V2", "V3", "variable"))
    print("merging 3")
    rm(m_hc2_data)
    write.table(bigdata, "bigdata_af.txt", quote=FALSE, sep="\t")
    bigdata = bigdata[complete.cases(bigdata),]
    colnames(bigdata) = c("CHR", "BP", "BP2", "COL", "UG", "HC200", "SAM", "HC2")
    # colnames(bigdata) = c("CHR", "BP", "SNP_FST", "FST", "SNP_XTX", "XTX", "SNP_BEXTX", "BEXTX", "SNP_OLDFST", "OLDFST")
    # colnames(bigdata) = c("CHR", "BP", "SNP_FST", "FST", "SNP_XTX", "XTX", "SNP_BEXTX", "BEXTX", "SNP_OLDFST", "OLDFST")
    bigdata_mini = bigdata[,c("UG", "HC200", "SAM", "HC2")]
    corr = cor(bigdata)
    corr_mini = cor(bigdata_mini)
    write.table(bigdata, "bigdata2_af.txt", quote=FALSE, sep="\t")
    write.table(corr, "corr_af.txt", quote=FALSE, sep="\t")
    write.table(corr_mini, "corr_mini_af.txt", quote=FALSE, sep="\t")
}

main()
