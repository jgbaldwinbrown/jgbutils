library(qqman)
library(data.table)

plot_fst <- function() {
    data=as.data.frame(fread("manhatify_test/testout_manhat_format.txt", header=TRUE))
    data = data[!is.nan(data$P),]

    scale=300
      tiff("fst_mini.tif",
           width=2*4*scale, height=3*2*scale, res=scale, compression="lzw")
    manhattan(data, logp=FALSE, xlab="Contig", ylab=expression("F"["ST"]), main=expression("11-population F"["ST"]),
        suggestiveline=FALSE, genomewideline=FALSE)
    dev.off()
}


plot_quad <- function() {
    
    fstdata =as.data.frame(fread("manhatify_test/testout_manhat_format.txt", header=TRUE))
    fstdata = fstdata[!is.nan(fstdata$P),]
    xtxdata =as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/subsets/manhatify_test/xtxsorted.txt", header=TRUE))
    xtxdata = xtxdata[!is.nan(xtxdata$P),]
    bextxdata =as.data.frame(fread("./bayenv_xtx/out_manhat_format.txt", header=TRUE))
    bextxdata = bextxdata[!is.nan(bextxdata$P),]
    oldfstdata = as.data.frame(fread("/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/old_correct_fst/out_manhat_format_nonan.txt", header=TRUE))

    all_labels = LETTERS
    labels_index = 1
    tlin=2
    label_cex = 1.5
    point_cex=0.5

    scale=300
      tiff("quadrouple.tif",
           width=2*4*scale, height=3*2*scale*3, res=scale, compression="lzw")
        par(mfrow=c(4,1))
        par(mar=c(5.1,4.1,4.1,2.1))
        
        manhattan(fstdata,
            logp=FALSE,
            xlab="Contig",
            ylab=expression("F"["ST"]),
            main=expression("11-population F"["ST"]),
            suggestiveline=FALSE, genomewideline=FALSE
        )
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
        labels_index = labels_index+1
        
        manhattan(xtxdata,
            logp=FALSE,
            xlab="Contig",
            ylab=expression("XTX"),
            main=expression("11-population XTX"),
            suggestiveline=FALSE, genomewideline=FALSE
        )
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
        labels_index = labels_index+1
        
        manhattan(bextxdata,
            logp=FALSE,
            xlab="Contig",
            ylab=expression("BayEnv XTX"),
            main=expression("11-population BayEnv2 XTX"),
            suggestiveline=FALSE, genomewideline=FALSE
        )
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
        labels_index = labels_index+1
        
        manhattan(oldfstdata,
            logp=FALSE,
            xlab="Contig",
            ylab=expression("F"["ST"]),
            main=expression("UnifiedGenotyper 11-population F"["ST"]),
            suggestiveline=FALSE, genomewideline=FALSE
        )
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
        labels_index = labels_index+1
        
    dev.off()
}

main <- function() {
    
    #plot_fst()
    plot_quad()
    
}

main()

