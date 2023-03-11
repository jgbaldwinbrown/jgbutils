#!/bin/bash
set -e

cat paths.txt | while read i ; do
	pigz -p 8 -d -c "${i}"
done | \
mawk -F "\t" -v OFS="\t" '
BEGIN{print("##fileformat=vcf")}
/^[^#]/{print $1, $2, $3, $4, $5}
' | \
pigz -p 8 -c > allsnps.vcf.gz
