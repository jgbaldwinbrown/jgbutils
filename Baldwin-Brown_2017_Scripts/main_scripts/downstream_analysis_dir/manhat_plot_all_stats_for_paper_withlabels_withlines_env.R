library(qqman)
library(ggplot2)
#qq plot bayes factors with multiple window sizes:
manhatplot_fst_lfmm_xtx_bf <- function(inpath_fst,inpath_xtx,inpath_bf,inpref_lfmm,insuf_lfmm,outpref,npops,wins,zs,bfs,fsts,
                                       xtx_thresh = NA, bf_thresh = NA, lfmm_thresh = NA, fst_thresh = NA,
                                       xtx_hits = NA, bf_hits = NA, lfmm_hits = NA, fst_hits = NA,
                                       xtx_winthresh=NA,bf_winthresh=NA,lfmm_winthresh=NA,fst_winthresh=NA, lfmmwins = NA) {
  #here, inpath is the path to a snptable with bf values, and outpref is the prefix for all plots
  #npops is the number of populations (used for computing degrees of freedom)
  #wins is a vector of the sliding window sizes to be used for plotting
  tifoutpath = paste(outpref,"_multistat_forpaper_env.tif",sep="")
  tiff(tifoutpath,
       width=2*4*600, height=2*3*600, res=600, compression="lzw")
  par(mfrow=c(2,1))
  par(mar=c(5.1,4.1,4.1,2.1))
  all_labels = LETTERS
  labels_index = 1
  tlin=2
  label_cex = 1.5
  point_cex = 0.5
  print("done1")
  ######
  #lfmm:
  #if (is.na(lfmmwins)) {lfmmwins = wins}
  #for (myz in zs){
  #  inpath = paste(inpref_lfmm,myz,insuf_lfmm,sep="")
  #  data <- readRDS(inpath)
  #  for (mywin in wins){
  #    if (mywin == 1) {
  #      mycolname = "adjusted.p.values"
  #      tempthresh = lfmm_thresh
  #    } else {
  #      mycolname = paste("lfmm_pcombo_win",mywin,sep="")
  #      tempthresh = lfmm_winthresh
  #    }
  #    mydat <- data[,mycolname]
  #    mychrom <- data$sort_variable
  #    mypos <- data$POS
  #    #theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
  #    manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
  #    manhatdatlog <- data.frame(BP=mypos,P=-log10(mydat),CHR=mychrom)
  #    
  #    manhattan(manhatdatlog,logp=FALSE,xlab="Contig",ylab="BF",main="11-population LFMM p-value (censored, logged)",ylim=c(min(manhatdatlog$P),max(manhatdatlog$P)),
  #              suggestiveline=FALSE,genomewideline=tempthresh)
  #    mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  #    labels_index = labels_index + 1
  #    
  #  }
  #}
  print("done2")
  #######
  #bf:
  data <- readRDS(inpath_bf)
  for (mybf in bfs){
    for (mywin in wins){
      if (mywin == 1) {
        mycolname = paste("bf",mybf,sep="")
        myylab = expression("log"[10]*"(BF)")
        mymain = "11-population Bayes factor for\ncollection date (logged)"
      } else {
        mycolname = paste("bf",mybf,"_win",mywin,sep="")
        myylab = expression("log"[10]*"(BF), 25-SNP average")
        mymain = "11-population Bayes factor for\ncollection date (logged), 25-SNP average"
      }
      print("done2.1")
      mydat <- data[,mycolname]
      print("done2.2")
      mychrom <- data$chromnum
      print("done2.3")
      mypos <- data$chrompos
      print("done2.4")
      theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
      print("done2.5")
      manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
      print("done2.6")
      manhatdatlog <- data.frame(BP=mypos,P=log10(mydat),CHR=mychrom)
      
      print("done2.7")
      if (!is.na(bf_thresh)){
        manhattan(manhatdatlog,logp=FALSE,xlab="Contig",ylab=myylab,main=mymain,ylim=c(min(manhatdatlog$P),max(manhatdatlog$P)),
                  suggestiveline=FALSE,genomewideline=log10(bf_thresh),cex=point_cex)
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
        labels_index = labels_index + 1
        
      } else {
        manhattan(manhatdatlog,logp=FALSE,xlab="Contig",ylab=myylab,main=mymain,ylim=c(min(manhatdatlog$P),max(manhatdatlog$P)),
                  suggestiveline=FALSE,genomewideline=log10(bf_winthresh))
        mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex,cex=point_cex)
        labels_index = labels_index + 1
      }
    }
  }
  print("done3")
  #######
  dev.off()
}


myinpref_lfmm <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s"
myinsuf_lfmm <- ".9.zscoreavg.withchroms.withhead.sorted.multiwin_1000.RDS"
myin_fst <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/python_fst/fst_multiwin/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.RDS"
myin_xtx <- "dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS"
myin_bf <- myin_xtx

myoutpref <- "manhat_plot_allstats_withlabels_withlines_5avg"
mynpops <- 11
mywins <- c(1,25)
mylfmmwins <- c(1,1000)

myzs <- c(8)
mybfs <- c(2)
myfsts <- c("mean")

#mybfs_conv1 <- (mybfs - 2) / 3 + 1
mybfs_conv1 <- mybfs - 1

myxtx_thresh <- read.table("xtx_thresh_11pop.txt")[1,1]
mybf_thresh <- read.table("bf_thresh_11pop.txt")[1,mybfs_conv1]
mylfmm_thresh <- read.table("lfmm_thresh_11pop.txt")[1,((myzs-1)*3)+1]
myfst_thresh <- read.table("gene_association/fst_significance_data/fst_mean_sigthresh_fst_nowin.txt")[1,1]

myxtx_thresh_win <- read.table("xtx_thresh_11pop_25win.txt")[1,1]
mybf_thresh_win <- read.table("bf_thresh_11pop_25win.txt")[1,mybfs_conv1]
mylfmm_thresh_win <- read.table("lfmm_thresh_11pop_100win.txt")[1,((myzs-1)*3)+1]
myfst_thresh_win <- read.table("gene_association/fst_significance_data/fst_mean_sigthresh_fst.txt")[1,1]


manhatplot_fst_lfmm_xtx_bf(myin_fst,myin_xtx,myin_bf,myinpref_lfmm,myinsuf_lfmm,
                       myoutpref,mynpops,mywins,
                       myzs,mybfs,myfsts,
                       xtx_thresh=myxtx_thresh,bf_thresh=mybf_thresh,lfmm_thresh=mylfmm_thresh,fst_thresh=myfst_thresh,
                       xtx_winthresh=myxtx_thresh_win,bf_winthresh=mybf_thresh_win,lfmm_winthresh=mylfmm_thresh_win,fst_winthresh=myfst_thresh_win,
                       lfmmwins=mylfmmwins)



# a<- rnorm(1000,0,1)
# b<-rnorm(1000,0,2)
# c<-rnorm(1000,0,3)
# d<-rnorm(1000,0,4)
# #quartz(w=6,h=8)
# par(mfrow=c(2,2))
# #par(mai=c(1,0,1,1))
# par(mar=c(3,2,4,1))
# #par(plt=c(1.1,1.1,1.1,1.1))
# tlin=2
# hist(a)
# mtext("A",3, line=tlin, adj=0, cex=2)
# hist(b)
# mtext("B",3, line=tlin, adj=0, cex=2)
# hist(c)
# mtext("C",3, line=tlin, adj=0, cex=2)
# hist(d)
# mtext("D",3, line=tlin, adj=0, cex=2)
