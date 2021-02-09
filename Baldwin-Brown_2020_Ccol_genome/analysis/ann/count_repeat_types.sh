cat all_repeats_small.txt | \
sed 's/[|_-][^	]*$//' | \
awk '{a[$5] += $4} END{for (key in a) {printf("%d\t%s\n", a[key], key)}}' | \
sort -k 1,1n > repeat_type_counts.txt
