# Versions of the statistical test

## normal_nor.R

The original version, identifies one sample's deviation from the
expectation based on all blood samples using a t-test.

## normal_nor_full.R

Like normal_nor.R, but instead of only using tissue as a factor in the
linear model, uses tissue and chromosome (why would you want this?)

## normal_nor_f.R

Like normal_nor.R, but does an f-test instead of a t-test, so it should
identify differences in variance (important for finding distortion
in autosomes).

## _mini

All of the _mini suffixes mean the same thing: take only 10 of the individuals, rather than
all individuals,
when running the test. Just for testing purposes.

## normal_nor_full_abs.R

Like normal_nor_full.R, but uses the absolute value of the difference from expectation for the t-test.
The idea is a sort of improvised f-test. Not useful compared to actual f-test.

## _cov

indicates that covariance with GC of chromosome is taken into account.
Should correct for gc bias as observed in the paper. Make sure you're
actually calculating a different gc bias level for each individual.

## Tests actually used in the published paper:

- normal_nor.R: Non-GC-corrected sex distortion test, SNP chip
- normal_nor_f.R: Autosome distortion test, SNP chip
- normal_nor_cov.R: GC-corrected sex distortion test, SNP chip
