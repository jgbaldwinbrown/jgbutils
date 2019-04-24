library(reshape2)
library(zoo)

my_structured_anova <- function(x){
    return(my_anova(structured(x)))
}

structured <- function(x){
    ax <- x[,1]
    a <- data.frame(pos=as.character(1:length(ax)),treat=rep("a",length(ax)),variable=rep("X0",length(ax)),value=ax)
    bx <- x[,2:ncol(x)]
    bd <- data.frame(pos=as.character(1:nrow(bx)),bx,treat=rep("b",nrow(bx)))
    bdm <- melt(bd,id.vars = c("pos","treat"))
    ab <- as.data.frame(rbind(a,bdm))
    return(ab)
}
my_anova <- function(ab){
    return(aov(data=ab,formula=value~variable+pos))
}
my_structured_nested_random_anova <- function(x){
    return(my_anova(structured(x)))
}
my_nested_random_anova <- function(ab){
    return(aov(data=ab,formula=value~variable+pos))
}
my_structured_2random_anova <- function(x){
    return(my_2random_anova(structured(x)))
}
my_2random_anova <- function(ab){
    return(aov(data=ab,formula=value~treat+Error(pos+variable)))
}
my_pval <- function(my_aov){
    return(summary(my_aov)[[2]][[1]]["Pr(>F)"][[1]][1])
}
my_structured_2random_anova_pval <- function(x){
    return(my_pval(my_structured_2random_anova(x)))
}

multitest_2random_anova <- function(x,excols,concols){
    out=rep(NA,length(excols))
    for (i in excols) {
        out[i] <- my_structured_2random_anova_pval(x[,c(excols[i],concols)])
    }
    return(out)
}

roll_multitest <- function(x,excols,concols,size,step){
    my_half <- round((size-1) / 2)
    my_starts <- seq(1,nrow(x)-(size-1),by=step)
    my_ends <- my_starts+(size-1)
    my_mids <- my_starts + my_half
    tempout <- as.data.frame(matrix(ncol=length(excols),nrow=length(my_starts)))
    for (i in 1:nrow(tempout)){
        tempout[i,] <- multitest_2random_anova(x[my_starts[i]:my_ends[i],],excols,concols)
    }
    out <- as.data.frame(cbind(my_starts,my_ends,my_mids,tempout))
    return(out)
}
