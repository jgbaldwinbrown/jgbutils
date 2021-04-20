#!/bin/bash
#SBATCH -t 72:00:00    #max:    72 hours (24 on ash)
#SBATCH -N 1          #format: count or min-max
#SBATCH -A shapiro    #values: yandell, yandell-em (ember), ucgd-kp (kingspeak)
#SBATCH -p kingspeak    #kingspeak, ucgd-kp, kingspeak-freecycle, kingspeak-guest
#SBATCH -J train_augustus_busco        #Job name

### #SBATCH -A owner-guest    #values: yandell, yandell-em (ember), ucgd-kp (kingspeak)
### #SBATCH -p kingspeak-guest    #kingspeak, ucgd-kp, kingspeak-freecycle, kingspeak-guest
set -e

module unload ucgd_utils
module unload ucgd_env
export MODULEPATH=`echo $MODULEPATH | sed 's/\(^\|:\)[^:]*ucgd[^:]*\(:\|$\)/:/'`
module load busco

export FASTA=/scratch/general/lustre/u6012238/louse/maker/ref/louseref_1scaf.fasta
export OPATH=/scratch/general/lustre/u6012238/louse/maker/aug_train_busco2_out/
export LPATH=${OPATH}/insecta_odb9/
export SP=columbicola_columbae2
export OPREFIX=augustus_train2
export AUG_ORIG_CONF=/uufs/chpc.utah.edu/sys/installdir/augustus/3.3/config/
export AUGUSTUS_CONFIG_PATH=${OPATH}/augustus_dir
export AUGUSTUS_SPECIES_DIR=${AUGUSTUS_CONFIG_PATH}/species/${SP}/
export START_DIR=`pwd`

mkdir -p ${AUGUSTUS_SPECIES_DIR}

cd $OPATH
wget http://busco.ezlab.org/v2/datasets/insecta_odb9.tar.gz
tar -xzvf insecta_odb9.tar.gz
rsync -avP $AUG_ORIG_CONF ${AUGUSTUS_CONFIG_PATH}/

run_BUSCO.py -i $FASTA -o $OPREFIX -l $LPATH -m geno --cpu 1 --long --augustus_parameters='--progress=true'
#run_BUSCO.py -i $FASTA -o $OPREFIX -l $LPATH -m geno --cpu 1 --long -sp $SP --augustus_parameters='--progress=true'

cp $OPATH/augustus_output/retraining_parameters/* ${AUGUSTUS_SPECIES_DIR}

#augustus [parameters] --species=BUSCO_augustus_busco_3750827137 queryfilename > output.gff

