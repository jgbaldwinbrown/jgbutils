###bwa samse ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai $FDATAPATH | samtools view -q 20 -bS - | samtools sort - -o data/bam/${PREFIX}.dbam
#bwa sampe ${REFPATH} ${BWATEMPPATH}${PREFIX}.F.sai ${BWATEMPPATH}${PREFIX}.R.sai $FDATAPATH $RDATAPATH | samtools view -q 20 -bS - | samtools sort - ${HOMEPATH}/data/bam/${PREFIX}.dbam
