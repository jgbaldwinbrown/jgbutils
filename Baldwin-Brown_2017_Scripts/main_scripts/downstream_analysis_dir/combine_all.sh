mkdir simulated
for i in 1 2 3 4 5;
do
mkdir simulated/$i
find . -name '*\.xtx' | grep -E "/${i}/" | sort | xargs cat > simulated/${i}/XtX_simulated_${i}.txt
find . -name '*\.bf' | grep -E "/${i}/" | sort | xargs cat > simulated/${i}/bf_simulated_${i}.txt
done
