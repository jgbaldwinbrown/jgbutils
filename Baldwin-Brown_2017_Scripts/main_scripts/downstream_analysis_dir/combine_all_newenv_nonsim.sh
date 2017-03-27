mkdir newenv_nonsim
for i in 1 2 3 4 5;
do
mkdir newenv_nonsim/$i
find . -name '*\.xtx' | grep -E "./raw_newenvs" | grep -E "/${i}/" | sort | xargs cat > newenv_nonsim/${i}/XtX_newenv_nonsim_${i}.txt
find . -name '*\.bf' | grep -E "./raw_newenvs" | grep -E "/${i}/" | sort | xargs cat > newenv_nonsim/${i}/bf_newenv_nonsim_${i}.txt
done
