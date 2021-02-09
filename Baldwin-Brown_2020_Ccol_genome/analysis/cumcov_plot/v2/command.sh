mkdir -p temp/hic_scaffold

Rscript \
scripts/util/cumcov_plot_multiple_v3.R \
temp/hic_scaffold/hic_scaf_lengths.txt \
temp/canu/v2/canu_v2_lengths.txt \
temp/canu/v1/canu_v1_lengths.txt \
temp/canu/v3/clc_v3_lengths.txt \
temp/canu/v3/canu_v3_lengths.txt \
"Cumulative  coverage  of  various  assemblies" \
temp/hic_scaffold/hic_scaf_multiplot.pdf
