qsub -q bio,pub64,adl -hold_jid tc -N a -t 1-590 augustus.sh `pwd` ../trinity_out ../ref/split_v1
