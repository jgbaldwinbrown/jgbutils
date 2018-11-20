find . -name '*.sh' | grep -v 'fandr' | while read i
do
sed -i 's|MAINPATH=/bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/raw/|MAINPATH=data/raw/|g' $i
sed -i 's|REFPATH=/bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/ref/shrimp_qmerged.quiver.fasta|REFPATH=ref/peromyscus_assembly_polished_v1.fasta|g' $i
sed -i 's|BWATEMPPATH=/bio/jbaldwi1/shrimp_data/illumina_data_2/align/final_assembly/run1/data/bwa_temp/|BWATEMPPATH=data/bwa_temp/|g' $i
done
