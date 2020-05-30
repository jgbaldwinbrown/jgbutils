 2153  cat toconvlist.txt | while read i ; do a=${i}.count; cat $i | python3 freq2count.py > $a ; done
