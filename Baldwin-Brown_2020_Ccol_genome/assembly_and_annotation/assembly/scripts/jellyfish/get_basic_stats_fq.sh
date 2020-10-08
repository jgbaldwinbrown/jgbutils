python read_length_mean.py $1
perl /share/adl/jbaldwi1/find_n50_2.pl $1 
echo "number of contigs:" $(grep -cE "^>" $1)
echo "number of bases:" $(grep -vE "^>" $1 | tr -d '\n' | wc -c)
