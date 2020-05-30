#!/usr/bin/Rscript

# distance<-c(19,49,1981,991,104,131,158,167,30,1000,5000,100,150,11,20,33,1100,1300,1500,100,1400,900,300,100,2000,100,1900,500,600,700,3000,2500,400,792)
# LD.data<-c(0.6,0.47,0.018,0.8,0.7,0.09,0.09,0.05,0,0.001,0,0.6,0.4,0.2,0.5,0.4,0.1,0.08,0.07,0.5,0.06,0.11,0.3,0.6,0.1,0.9,0.1,0.3,0.29,0.31,0.02,0.01,0.4,0.5)
# n<-52
# HW.st<-c(C=0.1)
# HW.nonlinear<-nls(LD.data~((10+C*distance)/((2+C*distance)*(11+C*distance)))*(1+((3+C*distance)*(12+12*C*distance+(C*distance)^2))/(n*(2+C*distance)*(11+C*distance))),start=HW.st,control=nls.control(maxiter=100))
# tt<-summary(HW.nonlinear)
# new.rho<-tt$parameters[1]
# fpoints<-((10+new.rho*distance)/((2+new.rho*distance)*(11+new.rho*distance)))*(1+((3+new.rho*distance)*(12+12*new.rho*distance+(new.rho*distance)^2))/(n*(2+new.rho*distance)*(11+new.rho*distance)))


ld_info <- read.table("bigdistmean_refv3_300.txt")
#ld_info <- read.table("oldmeanall_pop6.txt")
#ld_info <- read.table("oldmeanall_pop8.txt")
#ld_info <- read.table("oldbigdist.txt")
ld_info$bp <- 1:nrow(ld_info)
#colnames(ld_info)[2] <- "r2"
colnames(ld_info)[1] <- "r2"
#ld_info <- ld_info[5:nrow(ld_info),]
#ld_info <- as.data.frame(rbind(ld_info[1:75,], ld_info[125:nrow(ld_info),]))
head(ld_info)

distance<- ld_info$bp
head(distance)
LD.data<-ld_info$r2
#myspline <- smooth.spline(distance, LD.data, df=length(distance), spar=.9)
#LD.data <- predict(myspline, distance)$y
head(LD.data)
#n<-37
n<-71
#n <- 844
HW.st<-c(C=0.1)
str(LD.data)
str(distance)
#HW.nonlinear<-nls(LD.data~((10+C*distance)/((2+C*distance)*(11+C*distance)))*(1+((3+C*distance)*(12+12*C*distance+(C*distance)^2))/(n*(2+C*distance)*(11+C*distance))),start=HW.st,control=nls.control(maxiter=1000), lower=0, algorithm="port")
#((10+c) / ((2+C) * 11+C)) * (1 + (((3+C)   
HW.nonlinear<-nls(LD.data~((10+C*distance)/((2+C*distance)*(11+C*distance)))*(1+((3+C*distance)*(12+12*C*distance+(C*distance)^2))/(n*(2+C*distance)*(11+C*distance))),start=HW.st,control=nls.control(maxiter=100))
#HW.nonlinear<-nls(LD.data~((10+C)/((2+C)*(11+C)))*(1+((3+C)*(12+12*C+(C)^2))/(n*(2+C)*(11+C))),start=HW.st,control=nls.control(maxiter=100))
tt<-summary(HW.nonlinear)
print(tt)
new.rho<-tt$parameters[1]
fpoints<-((10+new.rho*distance)/((2+new.rho*distance)*(11+new.rho*distance)))*(1+((3+new.rho*distance)*(12+12*new.rho*distance+(new.rho*distance)^2))/(n*(2+new.rho*distance)*(11+new.rho*distance)))
print(new.rho)
plot(distance,LD.data)
#extra = read.table("oldmeanall_pop8.txt")
#colnames(extra)[2] = "r2"
#extra$bp=1:nrow(extra)
#points(extra$bp, extra$r2, col='red')
#head(extra)

##population specific:
#ld_infos <- as.data.frame(t(read.table("distmeanall_refv3_amt1_new.txt")))
#ld_infos$bp <- 1:nrow(ld_info)
#head(ld_infos)
##covs <- c(54,19,41,30,32,37,180,71,74,32,232,42)
#covs <- c(71, 71)
#
#calc_rho <- function(r,d,cov) {
#  distance <- d
#  LD.data <- r
#  n <- cov
#  HW.st<-c(C=0.1)
#  HW.nonlinear<-nls(LD.data~((10+C*distance)/((2+C*distance)*(11+C*distance)))*(1+((3+C*distance)*(12+12*C*distance+(C*distance)^2))/(n*(2+C*distance)*(11+C*distance))),start=HW.st,control=nls.control(maxiter=100))
#  tt<-summary(HW.nonlinear)
#  new.rho<-tt$parameters[1]
#  fpoints<-((10+new.rho*distance)/((2+new.rho*distance)*(11+new.rho*distance)))*(1+((3+new.rho*distance)*(12+12*new.rho*distance+(new.rho*distance)^2))/(n*(2+new.rho*distance)*(11+new.rho*distance)))
#  return(new.rho)
#}
#
#myrhos <- rep(NA,1)
#for (i in 2:2) {
#  mycol = i
#  myr <- ld_infos[,mycol]
#  mybp <- ld_infos$bp
#  mycov <- covs[i]
#  myrhos[i] <- calc_rho(myr,mybp,mycov)
#}
#
#write(myrhos,"allrhos.txt")
#
#
#
#
#
