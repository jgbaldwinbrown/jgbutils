library(qqman)
library(ggplot2)
library(grid)
#qq plot bayes factors with multiple window sizes:

setLayout <- function(xdim=1,ydim=1){
  initmat <- c(0,0,2,0,1,3)
  imat3 <-   c(0,1,1,1,1,1,1,1)
  imat2 <-   c(0,1,1,1,1,0,0,0)
  imat1 <- imat2
  row1mat <- c(0,4,4,4,4,0,0,0)
  row2mat <- c(0,2,2,2,2,0,0,0)
  row3mat <- c(0,1,1,1,1,3,3,3)
  layoutmat <- matrix(rep(0,length(row1mat)*xdim*3*ydim),ncol=xdim*length(row1mat))
  for (i in 1:ydim){
    r1=i*3 - 2
    r2=i*3 - 1
    r3=i*3
    for (j in 1:xdim) {
      curx = j-1
      cury = i-1
      curpos <- curx + cury*xdim
      cols=seq(length(row1mat)*j-(length(row1mat)-1),length(row1mat)*j)
      layoutmat[r1,cols] <- row1mat + (curpos * imat1*4)
      layoutmat[r2,cols] <- row2mat + (curpos * imat2*4)
      layoutmat[r3,cols] <- row3mat + (curpos * imat3*4)
    }
  }
  mywidths <- rep(c(1/100,20/100,20/100,20/100,20/100,19/3/100,19/3/100,19/3/100),xdim*length(row1mat))
  myheights <- rep(c(1/10,1/10,8/10),ydim)
  layout(layoutmat,widths=mywidths,heights=myheights)
}

scatterBarLay <- function(x, dcol="blue", fit=NA, lhist=20, num.dnorm=5*lhist,bigmain="", ...){
  ## check input
  stopifnot(ncol(x)==2)
  ## set up layout and graphical parameters
  ospc <- 0.5 # outer space
  pext <- 4 # par extension down and to the left
  bspc <- 1 # space between scatter plot and bar plots
  #par. <- par(mar=c(pext, pext, bspc, bspc),
  #            oma=rep(ospc, 4)) # plot parameters
  ## scatter plot
  par(mar = c(5.1,4.1,0,0))
  plot(x, xlim=range(x[,1]), ylim=range(x[,2]), ...)
  if (!is.na(fit)) {
    abline(fit)
  }
  ## 3) determine barplot and height parameter
  ## histogram (for barplot-ting the density)
  xhist <- hist(x[,1], plot=FALSE, breaks=seq(from=min(x[,1]), to=max(x[,1]),
                                              length.out=lhist))
  yhist <- hist(x[,2], plot=FALSE, breaks=seq(from=min(x[,2]), to=max(x[,2]),
                                              length.out=lhist)) # note: this uses probability=TRUE
  ## determine the plot range and all the things needed for the barplots and lines
  #   xx <- seq(min(x[,1]), max(x[,1]), length.out=num.dnorm) # evaluation points for the overlaid density
  #   xy <- dnorm(xx, mean=mean(x[,1]), sd=sd(x[,1])) # density points
  #   yx <- seq(min(x[,2]), max(x[,2]), length.out=num.dnorm)
  #   yy <- dnorm(yx, mean=mean(x[,2]), sd=sd(x[,2]))
  ## barplot and line for x (top)
  #par(mar=c(0, pext, 0, 0))
  par(mar = c(0,4.1,0,2.1))
  barplot(xhist$density, axes=FALSE, ylim=c(0, max(xhist$density)),
          space=0) # barplot
  #lines(seq(from=0, to=lhist-1, length.out=num.dnorm), xy, col=dcol) # line
  ## barplot and line for y (right)
  #par(mar=c(pext, 0, 0, 0))
  par(mar = c(5.1,0,0,2.1))
  barplot(yhist$density, axes=FALSE, xlim=c(0, max(yhist$density)),
          space=0, horiz=TRUE) # barplot
  #lines(yy, seq(from=0, to=lhist-1, length.out=num.dnorm), col=dcol) # line
  ## restore parameters
  #add title:
  #mtext(bigmain, side=3, outer=TRUE, line=-3)
  par(mar = c(0,0,0,0))
  plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
  text(x = 0.5, y = 0.5, bigmain, 
       cex = 2, col = "black")
  par(mar = c(5.1,4.1,4.1,2.1))
  #par(par.)
}


getQuantileMini <- function(x,p1=0,p2=1){
  q1 = quantile(x,p1)
  q2 = quantile(x,p2)
  out = x[x>=q1&x<=q2]
  return(out)
}

delta = function(par,dataVector){
  Nf = length(dataVector)
  Nlb = as.integer(0.10*Nf)
  Nub = as.integer(0.80*Nf)
  quants = (Nlb:Nub)/Nf - 1/(2*Nf)
  myDist = par[1]*qgamma(quants,par[2],par[3])
  SS = sum((myDist-dataVector[Nlb:Nub])^2)
  # the log helps with convergence -- see "tol"
  cat(log(SS),"\t",par[1],"\t",par[2],"\t",par[3],"\n")  # this lets you watch "progress", each iteration there are several evaluations
  log(SS)
}

qqplot_fst_lfmm_xtx_bf <- function(inpath_fst,inpath_xtx,inpath_bf,inpath_sweed,inpref_lfmm,insuf_lfmm,outpref,npops,wins,zs,bfs,fsts,
  inpath_xtx_sim="None", inpath_bf_sim="None",inpath_fst_sim="None") {
  #here, inpath is the path to a snptable with bf values, and outpref is the prefix for all plots
  #npops is the number of populations (used for computing degrees of freedom)
  #wins is a vector of the sliding window sizes to be used for plotting
  tifoutpath = paste(outpref,"_env_multistat_forpaper_hill.tif",sep="")
    tiff(tifoutpath,
       width=2*5*600, height=1*5*600, res=600, compression="lzw")
       #width=length(wins)*4*600, height=2*4*600, res=600, compression="lzw")
  #par(mfrow=c(2,length(wins)))
  #par(mfrow=c(1,2))
  nrow=1
  ncol=2
  setLayout(ncol,nrow)
  par(mar=c(5.1,4.1,4.1,2))
  all_labels = LETTERS
  labels_index = 1
  tlin=2
  label_cex = 1.5
  print("done1")
  #######
  #fst:
  #data <- readRDS(inpath_fst)
  mydata <- read.table("/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/bf_multiwin/dsbig_fused_bf23only_final.txt",
                     header=TRUE)

  myPar <- scan("/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/hill_climber_outs/bf/hill70_myPar_log10_bigrange_huge_2par_500range_positive.txt")
  myxtx <- log10(mydata$bf23)
  myxtx70 <- getQuantileMini(myxtx,0.1,0.8)
  smyxtx <- sort(myxtx)
  Nf = length(myxtx)
  N=length(myxtx)
  theory=qgamma((1:N)/N - 1/(2*Nf),myPar[1],myPar[2])
  exp=smyxtx
  N10 = round(N * .1)
  N80 = round(N*.8)
  theory70 = theory[N10:N80]
  exp70 = exp[N10:N80]
  fit <- lm(exp70~theory70)
  scatterBarLay(cbind(theory,exp),bigmain=expression(atop('log'[10]*'(Bayes factor) for','pool surface area Q-Q plot')),xlab=expression('Gamma distribution fit to log'[10]*'(BF)'),ylab=expression('log'[10]*'(BF)'),pch=20,fit=fit)
  #plot(theory,exp,main=expression(atop('log'[10]*'(Bayes factor) for','pool surface area Q-Q plot')),xlab=expression('Gamma distribution fit to log'[10]*'(BF)'),ylab=expression('log'[10]*'(BF)'))
  #abline(fit)
  #grid()
  #rug(theory,side=1)
  #rug(exp,side=2)
  #mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  labels_index = labels_index + 1
  
      #qq <- qqplot(theorybfs,mydat,main=paste("FST: ",mywin,"-snp window",sep=""),xlab="uniform p-value FST",ylab="experimental FST",
      #       pch=".")
      #grid()
      #testq <- getQuantileMini(mydat,0.1,0.8)
      #theoryq <- getQuantileMini(theorybfs,0.1,0.8)
      #testq <- na.omit(testq)
      #theoryq <- na.omit(theoryq)
      #if (length(testq) < length(theoryq)) {theoryq <- theoryq[1:length(testq)]}
      #if (length(theoryq) < length(testq)) {testq <- testq[1:length(theoryq)]}
      #fit <- lm(testq~theoryq,data=qq)
      #abline(fit)
      ##lines(rbind(c(-10000,-10000),c(10000,10000)))
  print("done4")
  #######
  #xtx:
  mydata <- readRDS("/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/lfmm/lfmm_replicated_9anc/dsbig_snp_freqmat_fused_cens.txt.K9.s8.9.zscoreavg.withchroms.withhead.sorted.multiwin.RDS")

  myPar <- scan("/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/hill_climber_outs/lfmm/hill70_myPar_minlog10_bigrange_huge_2par_500range_positive.txt")
  myxtx <- -log10(mydata$adjusted.p.values)
  myxtx70 <- getQuantileMini(myxtx,0.1,0.8)
  smyxtx <- sort(myxtx)
  Nf = length(myxtx)
  N=length(myxtx)
  theory=qgamma((1:N)/N - 1/(2*Nf),myPar[1],myPar[2])
  exp=smyxtx
  N10 = round(N * .1)
  N80 = round(N*.8)
  theory70 = theory[N10:N80]
  exp70 = exp[N10:N80]
  fit <- lm(exp70~theory70)
  scatterBarLay(cbind(theory,exp),bigmain=expression(atop('LFMM -log'[10]*'(p-value) for','pool surface area Q-Q plot')),xlab=expression('Gamma distribution fit to -log'[10]*'(p)'),ylab=expression('-log'[10]*'(p)'),pch=20,fit=fit)
  #plot(theory,exp,main=expression(atop('LFMM -log'[10]*'(p-value) for','pool surface area Q-Q plot')),xlab=expression('Gamma distribution fit to -log'[10]*'(p)'),ylab=expression('-log'[10]*'(p)'))
  #abline(fit)
  #grid()
  #rug(theory,side=1)
  #rug(exp,side=2)
  #mtext(all_labels[labels_index],3, line=tlin, adj=0, cex=label_cex)
  labels_index = labels_index + 1
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
mywins <- c(1)

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




