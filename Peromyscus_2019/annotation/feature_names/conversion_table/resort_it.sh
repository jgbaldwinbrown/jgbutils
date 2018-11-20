cat $1 | tr -d 'C' | sed 's/\.g/ /g' | sort -t ' ' -k1,1n -k 2,2n
