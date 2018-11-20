mkdir -p split_v1
python splitfasta.py Freeze_PP.fa split_v1/chrom 1000000
mv therest.fasta split_v1
