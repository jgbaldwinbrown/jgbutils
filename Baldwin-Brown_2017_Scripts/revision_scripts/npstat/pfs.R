#!/usr/bin/env Rscript

library(poolfstat)

data = genobaypass2pooldata(genobaypass.file="lsa.geno", poolsize.file="lsa.poolsize")
str(data)
fst = computeFST(data)

# Computes pairwise FST and returns a matrix for all pairs. NbOfSnps refers to the number of snps that passed filtering and were used in the calculation.
#pairfstmat = computePairwiseFSTmatrix(data, output.snp.values=FALSE)

# same as pairfstmat, but gives single-snp fst estimates also
# PairwiseSnpQ1 refers to the snp-specific Q1 estimate for each pair of pools
# PairwiseSnpQ2 refers to the snp-specific Q2 estimate for each pair of pools
#pairfstmat_snp = computePairwiseFSTmatrix(data, output.snp.values=TRUE)

write(fst$FST, file="fst.txt")
full_fst = fst$snp.FST
write(full_fst, file="full_fst.txt", ncolumns = 1)
