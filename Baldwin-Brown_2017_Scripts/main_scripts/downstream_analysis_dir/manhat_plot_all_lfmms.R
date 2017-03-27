library(qqman)
library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)
index = args[1]

#qq plot bayes factors with multiple window sizes:
multizqq <- function(inpref,insuf,outpref,npops,wins,zs,threshpath,threshpathwin,lfmmtitle,lfmmtitlewin) {
  #here, inpath is the path to a snptable with bf values, and outpref is the prefix for all plots
  #npops is the number of populations (used for computing degrees of freedom)
  #wins is a vector of the sliding window sizes to be used for plotting

#threshindex = as.numeric(index) - 1
#all_thresh <- scan(threshpath)
#mythresh <- all_thresh[threshindex]

  mylfmm_thresh <- read.table(threshpath)[1,((zs-1)*3)+1]
  mylfmm_thresh_win <- read.table(threshpathwin)[1,((zs-1)*3)+1]

  ind = 1
  for (myz in zs){
    inpath = paste(inpref,myz,insuf,sep="")
    data <- readRDS(inpath)
    tifoutpath <- paste(outpref,"_lfmm_zp",as.character(myz),".tif",sep="")
    tiff(tifoutpath,
         width=24*600, height=16*600, res=600, compression="lzw")
    par(mfrow=c(2,1))
    par(mar=c(5.1,6,6,2.1))
    par(oma=c(2,4,2,0))
    jind = 1
    for (mywin in wins){
      if (mywin == 1) {
        mycolname = "adjusted.p.values"
        tempthresh = mylfmm_thresh[ind]
        mytitle=lfmmtitle
      } else {
        mycolname = paste("lfmm_pcombo_win",mywin,sep="")
        tempthresh = mylfmm_thresh_win[ind]
        mytitle=lfmmtitlewin
      }
      mydat <- data[,mycolname]
      mychrom <- data$sort_variable
      mypos <- data$POS
      manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
      #manhatdatlog <- data.frame(BP=mypos,P=log10(mydat),CHR=mychrom)
      theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
      
      #manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="BF",main="11-population LFMM p-value (censored)",ylim=c(min(manhatdat$P),max(manhatdat$P)),
      #          suggestiveline=FALSE,genomewideline=FALSE)
      
      manhattan(manhatdat,logp=TRUE,xlab="Contig",ylab="-log10(p)",main=mytitle,ylim=c(0,6),
                suggestiveline=FALSE,genomewideline=tempthresh,cex.main=3,cex.lab=3)
      
      #qqplot(log10(theorybfs),log10(mydat),main=paste("LFMM p-value: ",mywin,"-snp window",sep=""),xlab="log10(uniform p-value)",ylab="log10(experimental p-value)",
      #       pch=".")
      #grid()
      #lines(rbind(c(-10000,-10000),c(10000,10000)))
      
      #qqplot(theorybfs,log10(mydat),main=paste("Bayes Factor: ",mywin,"-snp window",sep=""),xlab="uniform p-value",ylab="log10(experimental p-value)",
      #       pch=".")
      #grid()
      #lines(rbind(c(-10000,-10000),c(10000,10000)))
      
      #qqplot(theorybfs,mydat,main=paste("Bayes Factor: ",mywin,"-snp window",sep=""),xlab="uniform p-value",ylab="experimental p-value",
      #       pch=".")
      #grid()
      #lines(rbind(c(-10000,-10000),c(10000,10000)))
      jind = jind + 1
    }
    ind = ind + 1
    dev.off()
  }
}

zs_to_do <- 1:24

myinpref <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s"
myinsuf <- ".9.zscoreavg.withchroms.withhead.sorted.multiwin_1000.RDS"
myoutpref <- "lfmm_all_plots/dsbig_fused_lfmm"
mynpops <- 11
mywins <- c(1,100)
myzs <- c(as.numeric(index))
myzthreshin <- "lfmm_thresh_11pop.txt"
myzthreshwinin <- "lfmm_thresh_11pop_100win.txt"
labelpath <- "labels_combined2.txt"

labels = as.character(read.table(labelpath,sep="\t")$V1)
mylabelindex=as.numeric(index)
mylabel = labels[mylabelindex]
mytitlelfmm = mylabel
mytitlelfmmwin = mylabel

multizqq(myinpref,myinsuf,myoutpref,mynpops,mywins,myzs,myzthreshin,myzthreshwinin,mytitlelfmm,mytitlelfmmwin)

#"CHROM" "POS" "z.score" "adjusted.p.values" "sort_variable" "index_variable"    lfmm_zavg_win1  lfmm_pcombo_win1       
#lfmm_zavg_win3  lfmm_pcombo_win3        lfmm_zavg_win5  lfmm_pcombo_win5        lfmm_zavg_win9  lfmm_pcombo_win9        
#lfmm_zavg_win15 lfmm_pcombo_win15       lfmm_zavg_win25 lfmm_pcombo_win25
