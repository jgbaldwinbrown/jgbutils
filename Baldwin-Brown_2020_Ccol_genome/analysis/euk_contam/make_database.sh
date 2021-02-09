#!/bin/bash
set -e

mkdir -p db
mkdir -p louse

if [ ! -f db.fa.done ]; then
    cat \
        ./clivia/GCA_000337935.2_Cliv_2.1_genomic.fna.gz \
        ./human/GRCh38_latest_genomic.fna.gz | \
    pigz -p 8 -d -c \
    > db/db.fa
    touch db.fa.done
fi

if [ ! -f db.fa.db.done ] ; then
    (
        cd db
        makeblastdb -in db.fa -dbtype nucl -title human_pigeon
        touch db.fa.db.done
    }
fi

if [ ! -f louseref.fa.done ]; then
    cat ../pigeon_lice_ctgs_breaks_final_baccut.review.fasta.gz | \
    pigz -p 8 -d -c \
    > louse/louseref.fa
    touch louseref.fa.done
fi
