mkdir -p split_v1
python splitfasta.py peromyscus_assembly_polished_v1.fasta split_v1/chrom 1000000
mv therest.fasta split_v1
