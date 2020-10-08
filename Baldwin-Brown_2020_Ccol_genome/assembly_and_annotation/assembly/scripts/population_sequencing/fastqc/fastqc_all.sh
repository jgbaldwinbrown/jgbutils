cat scripts/population_sequencing/fastqc/all_fastq.txt | parallel -j 32 "fastqc {}"
