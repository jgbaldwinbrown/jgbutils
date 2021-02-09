ls *.* | while read i ;
do printf "\n" ;
    echo $i ;
    gunzip -c $i | head -n 2 ;
done > formats.txt ;
printf "\n\n\n" >> formats.txt ;

gunzip -c Pediculus_humanus.PhumU2.47.gff3.gz | \
awk '$3~/^(mRNA|gene)$/' | \
head -2 >> formats.txt
