#!/bin/bash
set -e

bash gffread_it.sh

mkdir -p ccolumbae

rsync -avP ../../../louseref* ./ccolumbae
rsync -avP ../../../pigeon* ./ccolumbae

#gunzip -c ./ccolumbae/louseref.all.sprot.interproscan_tsv.gff.gz | \
#mawk -F "\t" -v OFS="\t" '$3=="gene" || $3=="mRNA" || $3=="CDS"' > ../ccolumbae/ccolumbae.annotation.gff3

gunzip -c ./ccolumbae/louseref.all.sprot.interproscan_tsv.clean.sorted.baccut.gff.gz > ../ccolumbae/ccolumbae.annotation.gff3

gunzip -c ./ccolumbae/cds.fa.gz > ../ccolumbae/ccolumbae.annotation.cds
gunzip -c ./ccolumbae/louseref_untwelve.all.maker.baccut.proteins.fasta.gz > ../ccolumbae/ccolumbae.annotation.pep
gunzip -c ./ccolumbae/pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz > ../ccolumbae/ccolumbae.genome.fa
gunzip -c ./phumanus/Pediculus_humanus.PhumU2.dna.toplevel.fa.gz > ../phumanus/phumanus.genome.fa

gunzip -c ./phumanus/Pediculus_humanus.PhumU2.cds.all.fa.gz | \
sed 's/^>/&transcript:/g' \
> ../phumanus/phumanus.annotation.cds

gunzip -c ./phumanus/Pediculus_humanus.PhumU2.pep.all.fa.gz | \
sed 's/^>/&transcript:/g' | \
sed 's/^\(\S*\)-PA/\1-RA/g' | \
sed 's/^\(\S*\)-PB/\1-RB/g' \
> ../phumanus/phumanus.annotation.pep

gunzip -c phumanus/Pediculus_humanus.PhumU2.47.gff3.gz | \
python3 gff_id2name.py \
> ../phumanus/phumanus.annotation.gff3
