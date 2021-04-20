#!/bin/bash
set -e

module load maker/3

fasta_merge -d louseref_master_datastore_index.log
gff3_merge -d louseref_master_datastore_index.log
