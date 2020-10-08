export PATH=/data1/jbrown/local_programs/anaconda/install_dir/anaconda/bin:$PATH
source activate py35

read_fast5_basecaller.py -r -i /data1/jbrown/louse_project/raw_data/new_minion_rna/2 -t 64 -s /data1/jbrown/louse_project/temp/minion_rna_basecalling/2 -f FLO-MIN107 -k SQK-PCS108

source deactivate py35
