#!/bin/bash
mkdir bf_multiwin

#inarray=`head -1 bf_multiwin/dsbig_fused_partial_xtx_and_bf_withchroms_2sorted_cens_withhead_uniq_multiwin.txt | python -c '
#import sys
#for line in sys.stdin:
#    a=len(line.split())
#    b=range(2,a-6,3)
#print " ".join(map(str,b))'`

#echo $inarray

cp bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin.txt temp1
for i in 77
do
    echo $i
    cat temp1 | python window_sorted_be_out_xtx.py 1 1 $i 75 True | \
    python window_sorted_be_out_xtx.py 3 1 $i 75 True | \
    python window_sorted_be_out_xtx.py 5 1 $i 75 True | \
    python window_sorted_be_out_xtx.py 9 1 $i 75 True | \
    python window_sorted_be_out_xtx.py 15 1 $i 75 True | \
    python window_sorted_be_out_xtx.py 25 1 $i 75 True > temp2
    cp temp2 temp1
done

cp temp2 bf_multiwin/dsbig_fused_xtx_and_bf_5combo_withchroms_2sorted_cens_withhead_uniq_multiwin_plusxtx.txt

rm temp1
rm temp2

#cat dsbig_fused_partial_xtx_and_bf_withchroms_withhead_cens_10_200_3_fixed_2sorted.txt | python window_sorted_be_out_multibf.py 5 1 -1 -3 True > dsbig_fused_partial_xtx_and_bf_withchroms_withhead_cens_10_200_3_fixed_2sorted_5win.txt
