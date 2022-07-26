#!/bin/bash
set -e

ls *selec*plfmt.bed | while read i ; do
	cat ${i} | \
	awkf '
	{
	    printf("%s\t%s\t%s", $1, $2-1, $2+10000)
	    for (i=3; i<=NF; i++) {
	        printf("\t%s", $i);
	    }
	    printf("\n");
	}
	' > `dirname $i`/`basename $i .bed`_bedified.bed
done
