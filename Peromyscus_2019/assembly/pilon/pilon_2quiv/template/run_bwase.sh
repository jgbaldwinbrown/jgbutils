#!/bin/sh
module load bwa/0.7.8
module load samtools/1.3

show_help() {
    echo "TODO: Usage message";
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?g:t:l:s:o:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    g)  genome=$OPTARG
        ;;
    l)  lib=$OPTARG;
	fq=$lib.fq
        ;;
    t)  maxT=$OPTARG
        ;;
    s)  stage=$OPTARG
        ;;
    o)  outpath=$OPTARG
        ;;
    esac
done

# Test for stage
if [ -z $stage ];
then
    stage=1
fi

if test "$stage" -ge 1 -a "$stage" -le 3;
then
    echo "stage is set to $stage";
else
    echo "please set stage to integer [1,3]";
    exit 1;
fi

# Test for genome.
if [ -z "$genome" ];
then
    echo "please specify genome with -g";
else
    echo "genome is set to '$genome'";
    if [ -e $genome ];
    then
	if [ ! -f $genome ] && [ ! -p $genome ];
	then
	    echo "genome isn't a regular file or a pipe";
	    exit 1;
	fi
    else
	echo "genome doesn't exist";
	exit 1;
    fi
fi

# Test for lib.
if [ -z "$lib" ];
then
    echo "please specify lib with -l";
else
    echo "lib is set to '$lib'";
    echo "fq is set to '$fq'";
    if [ -e $fq ];
    then
	if [ ! -f $fq ] && [ ! -p $fq ];
	then
	    echo "fq isn't a regular file or a pipe";
	    exit 1;
	fi
    else
	echo "fq doesn't exist";
	exit 1;
    fi
fi

#test for outpath
if [ -z "$outpath" ];
then
    echo "please specify outpath with -o";
else
    echo "outpath is set to '$outpath'";
    if [ -e $outpath ];
    then
        if [ ! -f $outpath ] && [ ! -p $outpath ] [ ! -d $outpath ];
        then
            echo "outpath isn't a regular file or a pipe";
            exit 1
        fi
    else
        echo "outpath doesn't exist";
        exit 1;
    fi
fi

baselib=`basename ${lib}`
outlib=${outpath}/${baselib}
outfq=${outlib}.fq

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# End of argument processing

if [ $stage -le 1 ];
then
    echo "processing stage 1: indexing $genome with bwa index";
    bwa index -a bwtsw $genome;
fi

if [ $stage -le 2 ];
then
    echo "processing stage 2: aligning $fq to $genome with bwa aln";
    bwa aln -t $maxT $genome $fq > ${outfq}.sai
fi

if [ $stage -le 3 ];
then
    echo "processing stage 3: sorting and indexing alignments of $fq to $genome";
    bwa samse $genome ${outfq}.sai $fq \
	| tee ${outlib}.bwase.sam \
	| samtools sort -O bam -@ $maxT - \
	| tee ${outlib}.bwase.sorted.bam \
	| samtools index - ${outlib}.bwase.sorted.bam.bai
fi
exit 0;
