#!sh

module load blat
module load augustus
module load perl

cd $1
runnum=`echo "${SGE_TASK_ID} + 1" | bc`

INFILE=`ls $3/*.fasta | head -n $runnum | tail -n 1`
INFILE_BASE=`basename $INFILE .fasta`
blat -minIdentity=92 $INFILE $2/Trinity.fasta $INFILE_BASE.psl
perl ../blat2hints.pl --in=$INFILE_BASE.psl --out=$INFILE_BASE.hints.E.gff
augustus --species=fly --hintsfile=$INFILE_BASE.hints.E.gff --extrinsicCfgFile=extrinsic.ME.cfg $INFILE --gff3=on --uniqueGeneId=true > $INFILE_BASE.gff3

