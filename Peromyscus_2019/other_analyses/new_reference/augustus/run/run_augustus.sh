qsub -q bio,abio,free64,pub64,free48,adl -hold_jid tc -N a -t 1-25 augustus.sh `pwd` ../trinity_out ../ref/split_v1
