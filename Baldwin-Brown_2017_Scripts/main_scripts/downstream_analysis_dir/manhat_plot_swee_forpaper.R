library(qqman)
library(ggplot2)
#qq plot bayes factors with multiple window sizes:
manhatplot_fst_lfmm_xtx_bf <- function(inpath_fst,inpath_xtx,inpath_bf,inpath_sweed,inpref_lfmm,insuf_lfmm,outpref,npops,wins,zs,bfs,fsts,
                                       xtx_thresh = NA, bf_thresh = NA, lfmm_thresh = NA, fst_thresh = NA, sweed_thresh=NA, sweed_alphathresh=NA,
                                       xtx_hits = NA, bf_hits = NA, lfmm_hits = NA, fst_hits = NA,
                                       xtx_winthresh=NA,bf_winthresh=NA,lfmm_winthresh=NA,fst_winthresh=NA, sweed_winthresh=NA, sweed_alphawinthresh=NA, lfmmwins = NA) {
  #here, inpath is the path to a snptable with bf values, and outpref is the prefix for all plots
  #npops is the number of populations (used for computing degrees of freedom)
  #wins is a vector of the sliding window sizes to be used for plotting
  tifoutpath = paste(outpref,"_sweed_multistat_forpaper.tif",sep="")
  tiff(tifoutpath,
       width=length(wins)*8*600, height=4*600, res=600, compression="lzw")
  par(mfrow=c(1,length(wins)))
  par(mar=c(3,2,4,1))
  all_labels = LETTERS
  labels_index = 1
  tlin=2
  label_cex = 1.5
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
  #print("done2")
  #######
  ##bf:
  #data <- readRDS(inpath_bf)
  #for (mybf in bfs){
  #  for (mywin in wins){
  #    if (mywin == 1) {
  #      mycolname = paste("bf",mybf,sep="")
  #    } else {
  #      mycolname = paste("bf",mybf,"_win",mywin,sep="")
  #    }
  #    print("done2.1")
  #    mydat <- data[,mycolname]
  #    print("done2.2")
  #    mychrom <- data$chromnum
  #    print("done2.3")
  #    mypos <- data$chrompos
  #    print("done2.4")
  #    theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
  #    print("done2.5")
  #    manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
  #    print("done2.6")
  #    manhatdatlog <- data.frame(BP=mypos,P=log10(mydat),CHR=mychrom)
  #    
  #    print("done2.7")
  #    if (!is.na(bf_thresh)){
  #      manhattan(manhatdatlog,logp=FALSE,xlab="Contig",ylab="BF",main="11-population Bayes Factor (censored, logged)",ylim=c(min(manhatdatlog$P),max(manhatdatlog$P)),
  #                suggestiveline=FALSE,genomewideline=log10(bf_thresh))
  #      mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  #      labels_index = labels_index + 1
  #      
  #    } else {
  #      manhattan(manhatdatlog,logp=FALSE,xlab="Contig",ylab="BF",main="11-population Bayes Factor (censored, logged)",ylim=c(min(manhatdatlog$P),max(manhatdatlog$P)),
  #                suggestiveline=FALSE,genomewideline=log10(bf_winthresh))
  #      mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  #      labels_index = labels_index + 1
  #    }
  #  }
  #}
  #print("done3")
  ########
  ##fst:
  #data <- readRDS(inpath_fst)
  #
  #for (myfst in fsts){
  #  for (mywin in wins){
  #    if (mywin == 1) {
  #      mycolname = paste("fst_",myfst,sep="")
  #      tempthresh = fst_thresh
  #    } else {
  #      mycolname = paste("fst_",myfst,"_win",mywin,sep="")
  #      tempthresh = fst_winthresh
  #    }
  #    mydat <- data[,mycolname]
  #    mychrom <- data$chromnum
  #    mypos <- data$POS
  #    
  #    mylambda = 1/mean(mydat,na.rm=TRUE)
  #    theorybfs <- qexp(seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat)),rate=mylambda)
  #    manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
  #    manhatdat <- manhatdat[complete.cases(manhatdat),]
  #    manhatdat$CHR <- factor(manhatdat$CHR)
  #    llevels <- length(levels(manhatdat$CHR))
  #    levels(manhatdat$CHR) <- 1:llevels
  #    manhatdat$CHR <- as.numeric(manhatdat$CHR)
  #    manhatdatlog <- data.frame(BP=mypos,P=log10(sapply(mydat,FUN = function(x){
  #      if (!is.na(x)) {
  #        if (x <= 0) {1e-9} else {x}
  #      } else {x}
  #    })),CHR=mychrom)

  #    manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="FST",main="11-population FST (censored)",
  #              suggestiveline=FALSE,genomewideline=tempthresh)
  #    mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  #    labels_index = labels_index + 1
  #  }
  #}
  #print("done4")
  ########
  ##xtx:
  #data <- readRDS(inpath_xtx)
  #for (mywin in wins){
  #  if (mywin == 1) {
  #    tempthresh=xtx_thresh
  #    mycolname = "xtx"
  #  } else {
  #    tempthresh=xtx_winthresh
  #    mycolname = paste("xtx_win",mywin,sep="")
  #  }
  #  mydat <- data[,mycolname]
  #  mychrom <- data$chromnum
  #  mypos <- data$chrompos
  #  theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
  #  manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
  #  #manhatdatlog <- data.frame(BP=mypos,P=log10(mydat),CHR=mychrom)
  #  
  #  if (!is.na(xtx_thresh)) {
  #  manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="XTX",main="11-population XtX (censored)",ylim=c(min(manhatdat$P),max(manhatdat$P)),
  #            suggestiveline=FALSE,genomewideline=tempthresh)
  #  } else {
  #  manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="XTX",main="11-population XtX (censored)",ylim=c(min(manhatdat$P),max(manhatdat$P)),
  #            suggestiveline=FALSE,genomewideline=FALSE)
  #  }
  #  
  #  mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  #  labels_index = labels_index + 1
  #}
  #print("done5")
  
  data <- readRDS(inpath_sweed)
    mycolname = "Likelihood"
  mydat <- data[,mycolname]
  mychrom <- data$sort_variable
  mypos <- round(data$Position)
  manhatdat <- data.frame(BP=mypos,P=mydat,CHR=mychrom)
  manhatdat <- manhatdat[complete.cases(manhatdat),]
  manhatdat$CHR <- factor(manhatdat$CHR)
  llevels <- length(levels(manhatdat$CHR))
  levels(manhatdat$CHR) <- 1:llevels
  manhatdat$CHR <- as.numeric(manhatdat$CHR)
  theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))

  mycolnamealpha = "Alpha"
  mydatalpha <- data[,mycolnamealpha]
  mychromalpha <- data$sort_variable
  myposalpha <- round(data$Position)
  manhatdatalpha <- data.frame(BP=myposalpha,P=mydatalpha,CHR=mychromalpha)
  manhatdatalpha <- manhatdatalpha[complete.cases(manhatdatalpha),]
  manhatdatalpha$CHR <- factor(manhatdatalpha$CHR)
  llevelsalpha <- length(levels(manhatdatalpha$CHR))
  levels(manhatdatalpha$CHR) <- 1:llevels
  manhatdatalpha$CHR <- as.numeric(manhatdatalpha$CHR)
  if (!is.na(sweed_thresh)) {
    manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="SweeD CLR",main="11-population SweeD Composite Likelihood Ratio (censored)",
              suggestiveline=FALSE,genomewideline=sweed_thresh)
  
  } else {
    manhattan(manhatdat,logp=FALSE,xlab="Contig",ylab="SweeD CLR",main="11-population SweeD Composite Likelihood Ratio (censored)",
              suggestiveline=FALSE,genomewideline=FALSE)
    
  }
  
  if (!is.na(sweed_alphathresh)) {
    manhattan(manhatdatalpha,logp=FALSE,xlab="Contig",ylab="SweeD alpha",main="11-population SweeD Alpha (censored)",
              suggestiveline=FALSE,genomewideline=sweed_alphathresh)
    
  } else {
    manhattan(manhatdatalpha,logp=FALSE,xlab="Contig",ylab="SweeD alpha",main="11-population SweeD Alpha (censored)",
              suggestiveline=FALSE,genomewideline=FALSE)
  }
  
  print("done6")
  dev.off()
}


myinpref_lfmm <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/lfmm_multiwin/dsbig_snp_freqmat_fused_cens.txt.K9.s"
myinsuf_lfmm <- ".9.zscoreavg.withchroms.withhead.sorted.multiwin_1000.RDS"
myin_fst <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/python_fst/fst_multiwin/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.RDS"
myin_xtx <- "dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS"
myin_bf <- myin_xtx
myin_sweed <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/sweed_out/v2_complete/out_combo/sweed_full_allchroms_sorted.RDS"

myoutpref <- "manhat_plot_allstats_withlabels_withlines_5avg"
mynpops <- 11
mywins <- c(1,25)
mylfmmwins <- c(1,1000)

myzs <- c(8)
mybfs <- c(23)
myfsts <- c("mean")

#mybfs_conv1 <- (mybfs - 2) / 3 + 1
mybfs_conv1 <- mybfs - 1

myxtx_thresh <- read.table("xtx_thresh_11pop.txt")[1,1]
mybf_thresh <- read.table("bf_thresh_11pop.txt")[1,mybfs_conv1]
mylfmm_thresh <- read.table("lfmm_thresh_11pop.txt")[1,((myzs-1)*3)+1]
mysweed_thresh <- read.table("sweed_thresh_11pop.txt")[1,2]
mysweed_alphathresh <- read.table("sweed_thresh_11pop.txt")[1,3]
myfst_thresh <- read.table("gene_association/fst_significance_data/fst_mean_sigthresh_fst_nowin.txt")[1,1]

myxtx_thresh_win <- read.table("xtx_thresh_11pop_25win.txt")[1,1]
mybf_thresh_win <- read.table("bf_thresh_11pop_25win.txt")[1,mybfs_conv1]
mylfmm_thresh_win <- read.table("lfmm_thresh_11pop_100win.txt")[1,((myzs-1)*3)+1]
mysweed_thresh_win <- read.table("sweed_thresh_11pop_25win.txt")[1,2]
mysweed_alphathresh_win <- read.table("sweed_thresh_11pop_25win.txt")[1,3]
myfst_thresh_win <- read.table("gene_association/fst_significance_data/fst_mean_sigthresh_fst.txt")[1,1]


manhatplot_fst_lfmm_xtx_bf(myin_fst,myin_xtx,myin_bf,myin_sweed,myinpref_lfmm,myinsuf_lfmm,
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
