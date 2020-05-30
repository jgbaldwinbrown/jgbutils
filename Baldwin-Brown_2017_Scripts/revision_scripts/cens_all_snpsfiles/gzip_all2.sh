#rsync \
#	./ \
#	gzipped_for_laptop/ \
#	--files-from <( \
		find . -name '*snpsfile*' | \
		grep -E 'haplocaller_2(00)?ploid|samtools_popoolation|old(_correct)?' | \
		grep -vE 'backup|ation/old|gz'
#	) && \
#cd gzipped_for_laptop && \
#find . -type f | grep -v 'gz$' | xargs gzip
