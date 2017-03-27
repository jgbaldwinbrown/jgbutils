#!/bin/bash
mkdir bf_multiwin

inarray=`head -1 dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq.txt | python -c '
import sys
for line in sys.stdin:
    a=len(line.split())
    b=range(2,a-6,3)
print " ".join(map(str,b))'`

echo $inarray

cp dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq.txt tempbf1
for i in $inarray
do
    echo $i
    cat tempbf1 | python window_sorted_be_out_multibf.py 1 1 $i 75 True | \
    python window_sorted_be_out_multibf.py 3 1 $i 75 True | \
    python window_sorted_be_out_multibf.py 5 1 $i 75 True | \
    python window_sorted_be_out_multibf.py 9 1 $i 75 True | \
    python window_sorted_be_out_multibf.py 15 1 $i 75 True | \
    python window_sorted_be_out_multibf.py 25 1 $i 75 True > tempbf2
    cp tempbf2 tempbf1
done

cp tempbf2 bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin.txt

rm tempbf1
rm tempbf2

#cat dsbig_fused_partial_xtx_and_bf_withchroms_withhead_cens_10_200_3_fixed_2sorted.txt | python window_sorted_be_out_multibf.py 5 1 -1 -3 True > dsbig_fused_partial_xtx_and_bf_withchroms_withhead_cens_10_200_3_fixed_2sorted_5win.txt
