mkdir -p temp/population_sequencing/bwa/bwa_all/1
rsync -avP temp/pilon/v1/piloned.fasta temp/population_sequencing/bwa/bwa_all/1/piloned.fasta
bwa index temp/population_sequencing/bwa/bwa_all/1/piloned.fasta
find raw_data/population_sequencing/1/15515R/Fastq -name '*.fastq.gz' | \
sort | \
paste - - | \
while read i
do
    a=`echo $i | cut -d ' ' -f 1`
    b=`echo $i | cut -d ' ' -f 2`
    out=temp/population_sequencing/bwa/bwa_all/1/`basename $a _R1_001.fastq.gz`.bam
    bwa mem -t 32 temp/population_sequencing/bwa/bwa_all/1/piloned.fasta <(gunzip -c $a) <(gunzip -c $b) | samtools view -S -b > $out
    #echo $i $a $b $out
done
