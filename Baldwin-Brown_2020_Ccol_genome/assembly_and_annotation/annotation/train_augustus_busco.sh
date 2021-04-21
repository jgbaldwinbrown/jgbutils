#!/bin/bash
#SBATCH -t 72:00:00    #max:    72 hours (24 on ash)
#SBATCH -N 1          #format: count or min-max
#SBATCH -A shapiro    #values: yandell, yandell-em (ember), ucgd-kp (kingspeak)
#SBATCH -p kingspeak    #kingspeak, ucgd-kp, kingspeak-freecycle, kingspeak-guest
#SBATCH -J train_augustus_busco        #Job name

set -e

module load busco

export FASTA=/path/to/ref.fasta
export OPATH=/path/to/busco/output/dir/
export LPATH=${OPATH}/insecta_odb9/
export SP=augustus_species_name_ie_columbicola_columbae
export OPREFIX=augustus_train_run
export AUG_ORIG_CONF=/path/to/augustus/installation/augustus/3.3/config/
export AUGUSTUS_CONFIG_PATH=${OPATH}/augustus_dir
export AUGUSTUS_SPECIES_DIR=${AUGUSTUS_CONFIG_PATH}/species/${SP}/
export START_DIR=`pwd`

mkdir -p ${AUGUSTUS_SPECIES_DIR}

cd $OPATH
wget http://busco.ezlab.org/v2/datasets/insecta_odb9.tar.gz
tar -xzvf insecta_odb9.tar.gz
rsync -avP $AUG_ORIG_CONF ${AUGUSTUS_CONFIG_PATH}/

run_BUSCO.py -i $FASTA -o $OPREFIX -l $LPATH -m geno --cpu 1 --long --augustus_parameters='--progress=true'

cp $OPATH/augustus_output/retraining_parameters/* ${AUGUSTUS_SPECIES_DIR}
