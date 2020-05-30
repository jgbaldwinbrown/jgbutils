#!/usr/bin/Rscript

ld_info <- read.table("bigdistmean_refv3_300.txt")
ld_info$bp <- 1:nrow(ld_info)
colnames(ld_info)[1] <- "r2"

distance<- ld_info$bp
LD.data<-ld_info$r2
n<-32
HW.st<-c(C=0.1)
HW.nonlinear<-nls(LD.data~((10+C*distance)/((2+C*distance)*(11+C*distance)))*(1+((3+C*distance)*(12+12*C*distance+(C*distance)^2))/(n*(2+C*distance)*(11+C*distance))),start=HW.st,control=nls.control(maxiter=100))
tt<-summary(HW.nonlinear)
new.rho<-tt$parameters[1]
fpoints<-((10+new.rho*distance)/((2+new.rho*distance)*(11+new.rho*distance)))*(1+((3+new.rho*distance)*(12+12*new.rho*distance+(new.rho*distance)^2))/(n*(2+new.rho*distance)*(11+new.rho*distance)))
print(new.rho)
