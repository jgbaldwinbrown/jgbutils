# Peromyscus Assembly and Annotation Scripts

This is a collection of scripts used to generate the first draft Peromyscus
genome assembly and annotation. Many of these scripts are (currently) poorly
documented, but this is changing.

Preprocessing of the data required the following programs:

1. `prinseq`
2. `FastQ Screen`
3. `trimmomatic`

Generation of the genome assembly required the following programs:

1. `platanus`
2. `DBG2OLC`
3. `quickmerge`
4. `quiver`
5. `pilon`
6. `falcon`

Generation of the annotation required the following programs:

1. `trinity`
2. `augustus`
3. `extract_prot_seq_from_augustus_gff3.py`, a custom script
4. `BLAST`
5. `repeatmasker`

Many steps in the assembly and annotation pipeline were attempted with multiple
programs, with unsatisfactory results discarded in favor of higher-quality
results elsewhere. The following programs were tried, but not used in the final
assembly:

1. `abyss`
2. `PBCR`
3. `soap`

Analysis of the assembly and annotation required the following programs:

1. `BWA`
2. `canu`
3. `jellyfish`
4. `quake`
5. `DESeq`
6. `tophat`

The annotation information gathered from this assembly was eventually used to improve a later assembly. The following programs or scripts were required for this migration:


