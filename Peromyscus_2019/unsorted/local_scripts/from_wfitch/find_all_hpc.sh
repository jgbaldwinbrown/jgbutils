cd ~
screen -d hpc
screen -r hpc
cd /share/adl/jbaldwi1/all_d*/shr*
#find $PWD -type f | grep -E '\.fa|\.g[f|t]f'
find $PWD -type d -maxdepth 4
exit
