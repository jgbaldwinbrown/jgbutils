#!/bin/bash
set -e

mkdir -p run
cd run
rsync -avP ../ccolumbae .
rsync -avP ../phumanus .
rsync -avP ../Repo_spec.txt .
perl ../util/Create_full_repo_sequence_databases.pl -r ./Repo_spec.txt
perl ../util/Blast_grid_all_vs_all.pl -r ./Repo_spec.txt
perl ../util/Blast_all_vs_all_repo_to_OrthoMCL.pl -r ./Repo_spec.txt

# ALTERNATIVELY 1: ../util/Blast_all_vs_all_repo_to_RBH.pl -r ./Repo_spec.txt
# ALTERNATIVELY 2: ../util/Blast_all_vs_all_repo_to_Orthofinder.pl -r ./Repo_spec.txt

perl ../util/Orthologs_to_summary.pl -o all_orthomcl.out
perl ../util/DAGchainer_from_gene_clusters.pl -r ./Repo_spec.txt \
             -c GENE_CLUSTERS_SUMMARIES.OMCL/GENE_CLUSTERS_SUMMARIES.clusters
perl ../SynIma.pl -a Repo_spec.txt.dagchainer.aligncoords \
             -b Repo_spec.txt.dagchainer.aligncoords.spans

mkdir -p pretty_plot && cd pretty_plot && {
    
    if [ -f SynIma-output/config.txt ] ; then
        rm SynIma-output/config.txt
    fi
    rsync -avP ../ccolumbae .
    rsync -avP ../phumanus .
    
    mv ccolumbae/ccolumbae.genome.fa temp.fa
    cat temp.fa | \
    sed 's/PGA_scaffold_\([0-9]*\)_\S*/\1/g' \
    > ccolumbae/ccolumbae.genome.fa
    
    cat ../Repo_spec.txt.dagchainer.aligncoords | \
    sed 's/	PGA_scaffold_\([0-9]*\)_\S*/	\1/g' \
    >Repo_spec.txt.dagchainer.aligncoords
    
    cat ../Repo_spec.txt.dagchainer.aligncoords.spans | \
    sed 's/;PGA_scaffold_\([0-9]*\)_\S*/;\1/g' \
    >Repo_spec.txt.dagchainer.aligncoords.spans
    
    perl ../../SynIma.pl -a Repo_spec.txt.dagchainer.aligncoords \
                 -b Repo_spec.txt.dagchainer.aligncoords.spans
}
