#!/usr/bin/env Rscript

library(poolfstat)

main <- function() {
    baypassfile = "inter/snpsfile.txt"
    poolsizefile = "data/poolsize.txt"
    data = genobaypass2pooldata(genobaypass.file=baypassfile, poolsize.file=poolsizefile)
    fst = computeFST(data)

    # Computes pairwise FST and returns a matrix for all pairs. NbOfSnps refers to the number of snps that passed filtering and were used in the calculation.
    #pairfstmat = computePairwiseFSTmatrix(data, output.snp.values=FALSE)

    # same as pairfstmat, but gives single-snp fst estimates also
    # PairwiseSnpQ1 refers to the snp-specific Q1 estimate for each pair of pools
    # PairwiseSnpQ2 refers to the snp-specific Q2 estimate for each pair of pools
    #pairfstmat_snp = computePairwiseFSTmatrix(data, output.snp.values=TRUE)

    write(fst$FST, file="inter/fst.txt")
    full_fst = fst$snp.FST
    write(full_fst, file="inter/full_fst.txt", ncolumns = 1)
}

main()
