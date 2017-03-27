#manhattan plot function:

args <- commandArgs(trailingOnly=TRUE)
index = as.numeric(args[1])

library(qqman)

datapath="dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx_newenv.RDS"
threshpath="bf_thresh_11pop_newenv.txt"
threshpath_win="bf_thresh_11pop_25win_newenv.txt"
labelpath="labels_combined2_newenv.txt"

threshindex = as.numeric(index) - 1
all_thresh <- scan(threshpath)
mythresh <- all_thresh[threshindex]

threshindex_win = as.numeric(index) - 1
all_thresh_win <- scan(threshpath_win)
mythresh_win <- all_thresh_win[threshindex_win]

#print '\n'.join(map(str,range(2,72,3)))
labels = as.character(read.table(labelpath,sep="\t")$V1)
mylabelindex=(index - 2)/3 + 1
mylabel = labels[mylabelindex]
mytitlebf = mylabel
mytitlebfwin = mylabel

#bpcol = 75
#chrcol = 76
bpcol="chrompos"
chrcol="chromnum"
pcol1 = paste("bf",as.character(index),sep="")
pcol2 = paste("bf",as.character(index),"_win25",sep="")

  outpref = paste(c("dsbig_fused_bf",index,"_cens"),collapse="")

  bayenvout <- readRDS(datapath)
  bayenvout$SNP <- as.character(bayenvout$index)
  
  bayenvout5 <- bayenvout[,c(bpcol,chrcol,pcol1)]
  colnames(bayenvout5) <- c("BP","CHR","P")
  bayenvout5 <- bayenvout5[complete.cases(bayenvout5),]
  rownames(bayenvout5) <- 1:nrow(bayenvout5)
  bayenvout5$CHR <- factor(bayenvout5$CHR)
  llevels <- length(levels(bayenvout5$CHR))
  levels(bayenvout5$CHR) <- 1:llevels
  bayenvout5$CHR <- as.numeric(bayenvout5$CHR)
  bayenvout5 <- bayenvout5[order(bayenvout5$CHR,bayenvout5$BP),]
  #bayenvout5$P <- log10(as.numeric(bayenvout5$P))
  #as.numeric(levels(f))[f]
  if (is.factor(bayenvout5$P)) {
    bayenvout5$P <- as.numeric(levels(bayenvout5$P))[bayenvout5$P]
  }
  bayenvout5$P <- log10(bayenvout5$P)
  
  
  bayenvout5win25 <- bayenvout[,c(bpcol,chrcol,pcol2)]
  colnames(bayenvout5win25) <- c("BP","CHR","P")
  rm(bayenvout)
  #bayenvout5win25$CHR <- bayenvout5win25$CHR + 1
  bayenvout5win25 <- bayenvout5win25[complete.cases(bayenvout5win25),]
  rownames(bayenvout5win25) <- 1:nrow(bayenvout5win25)
  bayenvout5win25$CHR <- factor(bayenvout5win25$CHR)
  llevels <- length(levels(bayenvout5win25$CHR))
  levels(bayenvout5win25$CHR) <- 1:llevels
  bayenvout5win25$CHR <- as.numeric(bayenvout5win25$CHR)
  bayenvout5win25 <- bayenvout5win25[order(bayenvout5win25$CHR,bayenvout5win25$BP),]
  #bayenvout5win25$P <- log10(as.numeric(bayenvout5win25$P))
  #as.numeric(levels(f))[f]
  if (is.factor(bayenvout5win25$P)) {
    bayenvout5win25$P <- as.numeric(levels(bayenvout5win25$P))[bayenvout5win25$P]
  }
  bayenvout5win25$P <- log10(bayenvout5win25$P)

  tiff(paste(c("/home/jbaldwin/new_home/wild_shrimp_data/for_shrimp_paper_1/bwa_alignments/snp_tables/deduped/new_downsampled/full_fst_dsbig_fused/bayenv_5repavg/v4_full_data_fixedinput_splitout/bf_all_plots/",outpref,"_25win_newenv.tif"),collapse=""),
       width=24*600, height=16*600, res=600, compression="lzw")
  par(mfrow=c(2,1))
  par(mar=c(5.1,6,6,2.1))
  par(oma=c(2,4,2,0))
  manhattan(bayenvout5,logp=FALSE,xlab="Contig",ylab="log10(BF)",main=mytitlebf,ylim=c(0,20),
            suggestiveline=FALSE,genomewideline=log10(mythresh),cex.lab=3,cex.main=3)

  manhattan(bayenvout5win25,logp=FALSE,xlab="Contig",ylab="log10(BF)",main=mytitlebfwin,ylim=c(0,20),
            suggestiveline=FALSE,genomewideline=log10(mythresh_win),cex.lab=3,cex.main=3)

  dev.off()

