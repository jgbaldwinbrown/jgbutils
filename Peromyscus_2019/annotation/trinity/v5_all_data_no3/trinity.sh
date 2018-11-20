#!sh

#OGE script ready for use on UCI HPC cluster

cd $1

CORES=64

module load perl/5.16.2
module load trinity/20130216
module load bowtie/0.12.8
module load samtools/0.1.18
module load java/1.6

ulimit -s unlimited

#catenate fastq files

DOIT=0
for i in left.fa right.fa
do
    if [ ! -e $i ]
    then
	DOIT=1
    fi
done

shift
if [ $DOIT -eq 1 ]
then
    for var in "$@"
    do
	if `echo ${var} | grep "READ1" 1>/dev/null 2>&1`
	then
	    zcat $var | awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}'|perl -p -i -e 's/\s1:.+$/\/1/go' >> left.fa
	fi
	if `echo ${var} | grep "READ2" 1>/dev/null 2>&1`
	then
	    zcat $var | awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}'|perl -p -i -e 's/\s2:.+$/\/2/go' >> right.fa
	fi
    done
fi

perl -I $HOME/lib `which normalize_by_kmer_coverage.pl` --seqType fa --JM 100G --max_cov 30 --left left.fa --right right.fa --pairs_together --PARALLEL_STATS --JELLY_CPU $CORES
LEFTFILE=`ls | grep left.fa | grep normalized`
RIGHTFILE=`ls | grep right.fa | grep normalized`
/usr/bin/time -f "%e %M" -o time.txt Trinity.pl --seqType fa --bflyHeapSpaceInit 1G --bflyHeapSpaceMax 8G --JM 7G --left $LEFTFILE --right $RIGHTFILE --output trinity_output --min_contig_length 300 --CPU $CORES --inchworm_cpu $CORES --bflyCPU $CORES
