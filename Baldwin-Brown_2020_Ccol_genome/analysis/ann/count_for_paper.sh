{
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | grep -o '_AED=[0-9.]*' | sed 's/.*=//' > aeds.txt
    echo "number of genes:"
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | awk '$3=="gene"' | wc -l
    echo "number of transcripts:"
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | awk '$3=="mRNA"' | wc -l
    #gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | mawk -F "\t" -v OFS="\t" '$3=="gene"{print $9}' | grep -o 'Note=.*' | grep -o ';.*' | grep -o '[=,][^:]*:' | tr -d ',;:=' | sort | uniq -c | sort -k 1,1n
    echo "number of genes annotated by interproscan:"
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | mawk '$3=="gene"' | grep 'InterPro\|Pfam' | wc -l
    echo "number of genes annotated by sprot:"
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | mawk '$3=="gene"' | grep 'Note=Similar' | wc -l
    echo "number of genes annotated by both interproscan and sprot:"
    gunzip -c ../louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz | mawk '$3=="gene"' | grep 'InterPro\|Pfam\|Note=Similar' | wc -l
} > counted_for_paper.txt
