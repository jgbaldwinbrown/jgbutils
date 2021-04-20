mkdir -p splits_renamed

find splits_unedited -type f | while read i ; do
	gunzip -c ${i} | \
	sed '/scaffold_12_/s/>.*length_[0-9]*\(_split.*\)\?/>twelve\1/' | \
	gzip -c \
	> splits_renamed/`basename ${i}`
done


mkdir -p splits_reordered

find splits_renamed -type f | while read i ; do
	gunzip -c ${i} | \
	fa2tab | \
	grep "twelve" | \
	tab2fa | \
	gzip -c \
	> splits_reordered/`basename ${i}`
	
	gunzip -c ${i} | \
	fa2tab | \
	grep -v "twelve" | \
	tab2fa | \
	gzip -c \
	>> splits_reordered/`basename ${i}`
done
