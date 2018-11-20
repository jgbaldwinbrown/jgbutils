SHELL := /bin/bash

all: all_rnaseq_reads.txt

all_rnaseq_reads.txt: all_rnaseq_reads_sets12.txt all_rnaseq_reads_sets3.txt all_rnaseq_reads_set4.txt
	cat $^ > $@

