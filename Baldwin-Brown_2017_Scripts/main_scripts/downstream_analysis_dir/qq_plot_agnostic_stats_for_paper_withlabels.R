library(qqman)
library(ggplot2)
#qq plot bayes factors with multiple window sizes:

getQuantileMini <- function(x,p1=0,p2=1){
  q1 = quantile(x,p1)
  q2 = quantile(x,p2)
  out = x[x>=q1&x<=q2]
  return(out)
}

qqplot_fst_lfmm_xtx_bf <- function(inpath_fst,inpath_xtx,inpath_bf,inpath_sweed,inpref_lfmm,insuf_lfmm,outpref,npops,wins,zs,bfs,fsts,
  inpath_xtx_sim="None", inpath_bf_sim="None",inpath_fst_sim="None") {
  #here, inpath is the path to a snptable with bf values, and outpref is the prefix for all plots
  #npops is the number of populations (used for computing degrees of freedom)
  #wins is a vector of the sliding window sizes to be used for plotting
  tifoutpath = paste(outpref,"_agnostic_multistat_forpaper.tif",sep="")
    tiff(tifoutpath,
       width=length(wins)*4*600, height=2*4*600, res=600, compression="lzw")
  par(mfrow=c(2,length(wins)))
  par(mar=c(3,2,4,1))
  all_labels = LETTERS
  labels_index = 1
  tlin=2
  label_cex = 1.5
  print("done1")
  #######
  #fst:
  data <- readRDS(inpath_fst)
  
  for (myfst in fsts){
  if (inpath_fst_sim != "None") {simdat <- readRDS(inpath_fst_sim)[,2]}
    for (mywin in wins){
      if (mywin == 1) {
        mycolname = paste("fst_",myfst,sep="")
      } else {
        mycolname = paste("fst_",myfst,"_win",mywin,sep="")
      }
      mydat <- data[,mycolname]
      mychrom <- data$chromnum
      mypos <- data$POS
      
      if (inpath_fst_sim == "None"){
        mylambda = 1/mean(mydat,na.rm=TRUE)
        theorybfs <- qexp(seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat)),rate=mylambda)
      } else {
        theorybfs <- quantile(simdat,probs=ppoints(mydat))
      }
      
      qq <- qqplot(theorybfs,mydat,main=paste("FST: ",mywin,"-snp window",sep=""),xlab="uniform p-value FST",ylab="experimental FST",
             pch=".")
      grid()
      testq <- getQuantileMini(mydat,0.1,0.8)
      theoryq <- getQuantileMini(theorybfs,0.1,0.8)
      testq <- na.omit(testq)
      theoryq <- na.omit(theoryq)
      if (length(testq) < length(theoryq)) {theoryq <- theoryq[1:length(testq)]}
      if (length(theoryq) < length(testq)) {testq <- testq[1:length(theoryq)]}
      fit <- lm(testq~theoryq,data=qq)
      abline(fit)
      #lines(rbind(c(-10000,-10000),c(10000,10000)))
      mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
      labels_index = labels_index + 1
    }
  }
  print("done4")
  #######
  #xtx:
  data <- readRDS(inpath_xtx)
  if (inpath_xtx_sim != "None") {simdat <- readRDS(inpath_xtx_sim)[,2]}
  for (mywin in wins){
    if (mywin == 1) {
      mycolname = "xtx"
    } else {
      mycolname = paste("xtx_win",mywin,sep="")
    }
    mydat <- data[,mycolname]
    mychrom <- data$chromnum
    mypos <- data$chrompos
    if (inpath_xtx_sim == "None"){
      theorybfs <- seq(1/length(mydat),1-(1/length(mydat)),length.out=length(mydat))
    } else {
        theorybfs <- quantile(simdat,probs=ppoints(mydat))
    }
    
    qq <- qqplot(theorybfs,mydat,main=paste("XTX: ",mywin,"-snp window",sep=""),xlab="uniform p-value XTX",ylab="experimental XTX",
           pch=".")
    grid()
    testq <- getQuantileMini(ydat,0.1,0.8)
    theoryq <- getQuantileMini(theorybfs,0.1,0.8)
    testq <- na.omit(testq)
    theoryq <- na.omit(theoryq)
    if (length(testq) < length(theoryq)) {theoryq <- theoryq[1:length(testq)]}
    if (length(theoryq) < length(testq)) {testq <- testq[1:length(theoryq)]}
    fit <- lm(testq~theoryq,data=qq)
    abline(fit)
    #lines(rbind(c(-10000,-10000),c(10000,10000)))
    mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
    labels_index = labels_index + 1
  }
  print("done5")
  dev.off()
}

myinpref_lfmm <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/lfmm/lfmm_replicated_9anc/dsbig_snp_freqmat_fused_cens.txt.K9.s"
myinsuf_lfmm <- ".9.zscoreavg.withchroms.withhead.sorted.multiwin.RDS"
#myin_bf <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv/v2_complete/bf_multiwin/dsbig_fused_partial_xtx_and_bf_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS"
myin_fst <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/python_fst/fst_multiwin/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_sorted_fst_mean_multiwin_snpnames_chromnums.RDS"
myin_xtx <- "dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.RDS"
myin_bf <- myin_xtx
myin_sweed <- "/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/sweed_out/v2_complete/out_combo/sweed_full_allchroms_sorted.RDS"

myin_xtx_sim <- "simulated_mean_XtX_out.normalized_transposed_tank_info_11pop.RDS"
myin_bf_sim <- "simulated_mean_bf_environ.normalized_transposed_tank_info_11pop.RDS"

myoutpref <- "qq_plot_allstats_withlabels_5avg"
mynpops <- 11
mywins <- c(1,25)

myzs <- c(8)
mybfs <- c(23)
myfsts <- c("mean")

#function(inpath_fst,inpath_xtx,inpath_bf,inpref_lfmm,insuf_lfmm,outpref,npops,wins,zs,bfs,fsts)
qqplot_fst_lfmm_xtx_bf(myin_fst,myin_xtx,myin_bf,myin_sweed,myinpref_lfmm,myinsuf_lfmm,
                       myoutpref,mynpops,mywins,
                       myzs,mybfs,myfsts,
                       inpath_xtx_sim=myin_xtx_sim,inpath_bf_sim=myin_bf_sim)


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




