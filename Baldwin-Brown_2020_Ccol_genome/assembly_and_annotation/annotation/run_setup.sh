#!/bin/bash
#SBATCH -t 72:00:00   #max:    72 hours (24 on ash)
#SBATCH -N 1             #format: count or min-max
#SBATCH -A owner-guest    #values: yandell, yandell-em (ember), ucgd-rw (kingspeak)
#SBATCH -p kingspeak-guest    #kingspeak, ucgd-kp, kingspeak-freecycle, kingspeak-guest
#SBATCH -J maker-setup      #Job name

#only need this if you have not edited the ~/custom.sh file
#module use /uufs/chpc.utah.edu/common/PE/proj_UCGD/modulefiles/$UUFSCELL

export WORK=/uufs/chpc.utah.edu/common/home/shapiro-group1/jim/new/maker/final_run/final11_real_cleaned_alt_splice
export SCRIPTS=/scratch/ucgd/serial/common/shell_scripts/

#this sets up certain necessary variables and other stuff
source $SCRIPTS/slurm_job_prerun

#run serial or mpi job
cd $WORK
#ibrun -tcp maker maker_opts.ctl maker_bopts.ctl maker_exe.ctl

python3 setup_all.py
python3 run_all.py

#this cleans up everything on exit
source $SCRIPTS/slurm_job_postrun
