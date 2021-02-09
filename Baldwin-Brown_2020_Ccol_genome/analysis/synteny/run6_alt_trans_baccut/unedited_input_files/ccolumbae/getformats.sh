ls *.* | while read i ;
do printf "\n" ;
    echo $i ;
    gunzip -c $i | head -n 2 ;
done > formats.txt ;
printf "\n\n\n" >> formats.txt ;
gunzip -c louseref.all.sprot.interproscan_tsv.gff.gz | awk '$3~/^(mRNA|gene)$/' | head -2 >> formats.txt
