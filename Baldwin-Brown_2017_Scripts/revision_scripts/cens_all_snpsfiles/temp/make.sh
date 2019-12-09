cat only-PASS-Q30-SNPs-cov-11pop.txt | awk -F '\t' -v OFS="\t" 'NR>1 {print($2, ($3)-1, $3)}' > old_correct_bedin.bed
