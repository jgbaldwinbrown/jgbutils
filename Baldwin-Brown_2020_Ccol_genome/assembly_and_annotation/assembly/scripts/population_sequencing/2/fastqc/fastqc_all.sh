cat scripts/population_sequencing/2/fastqc/all_fastq.txt | parallel -j 32 "fastqc {}"
