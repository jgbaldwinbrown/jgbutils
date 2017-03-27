mkdir newenv_sim
for i in 1 2 3 4 5;
do
mkdir newenv_sim/$i
find . -name '*\.xtx' | grep -E "simulated_raw_newenvs" | grep -E "/${i}/" | sort | xargs cat > newenv_sim/${i}/XtX_newenv_sim_${i}.txt
find . -name '*\.bf' | grep -E "simulated_raw_newenvs" | grep -E "/${i}/" | sort | xargs cat > newenv_sim/${i}/bf_newenv_sim_${i}.txt
done
