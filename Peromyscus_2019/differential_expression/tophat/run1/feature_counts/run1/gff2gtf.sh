module load cufflinks

outname=`echo "$(basename $1 .gff3).gtf"`
gffread $1 -T -o $outname
