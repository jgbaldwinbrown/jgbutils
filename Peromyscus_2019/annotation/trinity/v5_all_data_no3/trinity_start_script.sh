cat all_inputs.txt | xargs qsub -q bio,adl -pe openmp 64 -R Y -N t -hold_jid trimmomatic trinity.sh `pwd`
