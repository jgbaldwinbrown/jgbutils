mypwd=`pwd`
cd dbg2olc && \
qsub run_dbg2olc.sh && \
cd ${mypwd}/consensus && \
qsub run_dbg2olc_consensus.sh && \
cd ${mypwd}/analysis && \
qsub run_dbg2olc_analysis.sh && \
cd quast && \
qsub run_quast.sh && \
cd ${mypwd}/analysis/gage && \
qsub gage_all2.sh
cd ${mypwd}
