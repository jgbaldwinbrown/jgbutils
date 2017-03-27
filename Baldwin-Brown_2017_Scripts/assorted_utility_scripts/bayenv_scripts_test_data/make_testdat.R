set.seed(1235231)

a=rnorm(1000000)
b=rnorm(1000000,mean=5)
c=rnorm(1000000,mean=10,sd=4)

d=cbind(a,b,c)

write.table(d,"testdat3.txt",col.names=FALSE)
