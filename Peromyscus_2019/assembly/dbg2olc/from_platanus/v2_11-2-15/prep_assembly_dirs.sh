#!/bin/bash

illpath=../ill_assembly/plat_assembly_contig.fa
pacpath=/dfs2/temp/bio/jbaldwi1/peromyscus_data/data/pacbio/1-10_combo/pero_pacbio_1-10_combo.fasta
suffix=pero_plat
queue=bio,pub64,som

rsync -avP ../ultimate_template2/* .

find . -name '*run*' | while read line
do
 sed -i "s|ILLPATH|${illpath}|g" ${line}
 sed -i "s|PACPATH|${pacpath}|g" ${line}
 sed -i "s|SUFFIX|${suffix}|g" ${line}
 sed -i "s|QUEUES|${queue}|g" ${line}
 sed -i "s|REFPATH|${refpath}|g" ${line}
done

#cd casey2
#mkdir runs
#mkdir downsampled_runs
#mkdir fringy_runs
#
#mkdir downsampled_runs/0.5
#mkdir downsampled_runs/0.75
#
##arrays associated with $i
#template_path=/pub/jbaldwi1/dbg2olc/mel/ultimate_template2
#root_paths=(runs downsampled_runs/0.5 downsampled_runs/0.75 fringy_runs)
#illpath=/pub/jbaldwi1/platanus/mel/plat_assembly_contig.fa
#pacpath_roots=(/pub/jbaldwi1/casey_data/subsampled_reads/ /pub/jbaldwi1/casey_data/subsampled_reads/downsample_longest/0.5/ /pub/jbaldwi1/casey_data/subsampled_reads/downsample_longest/0.75/ /pub/jbaldwi1/casey_data/downsample_to_fringy/subsample/from_bio/)
#pacpath_mids=(/casey_combo_ /casey_combo_ /casey_combo /cf1_)
#pacpath_ends=(cell.fastq.fa cell_dslength0.5.fastq.fa cell_dslength0.5.fastq.fa cell.fq.fa)
#refpath=/pub/jbaldwi1/dbg2olc/mel/ref/6.01/dmel-all-chromosome-r6.01.fasta
#suffix_roots=(van_ ds5_ ds75_ fri_)
#
##arrays associated with $j
#queues=(bio,pub64 bio,pub64 bio,pub64 bio,pub64 bio,abio bio,abio bio,abio bio,abio bio,abio bio,abio bio,abio)
#js=(3 5 8 10 12 15 20 25 30 35 40)
#
#mypwd=`pwd`
#
#for i in 0 1 2 3
#do
# for k in 0 1 2 3 4 5 6 7 8 9 10
# do
#  j=${js[${k}]}
#  fullpath=${root_paths[${i}]}/${j}
#  pacpath=${pacpath_roots[${i}]}${j}${pacpath_mids[${i}]}${j}${pacpath_ends[${i}]}
#  suffix=${suffix_roots[${i}]}${j}
#  queue=${queues[${k}]}
#  mkdir ${fullpath}
#  rsync -avP ${template_path}/* ${fullpath}/
#  cd ${fullpath}
#  find . -name '*run*' | while read line
#  do
#   sed -i "s|ILLPATH|${illpath}|g" ${line}
#   sed -i "s|PACPATH|${pacpath}|g" ${line}
#   sed -i "s|SUFFIX|${suffix}|g" ${line}
#   sed -i "s|QUEUES|${queue}|g" ${line}
#   sed -i "s|REFPATH|${refpath}|g" ${line}
#  done
#  cd ${mypwd}
# done
#done
#cd ${mypwd}
