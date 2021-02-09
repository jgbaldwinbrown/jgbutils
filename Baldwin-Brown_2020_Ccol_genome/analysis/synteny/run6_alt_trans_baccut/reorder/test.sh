#!/bin/bash
set -e

mkdir -p run && cd run && {
    
    rsync -avP ../../run/pretty_plot/* ./
    if [ ! -f old_config.txt ] ; then
        rsync -avP ../../run/pretty_plot/SynIma-output/config.txt old_config.txt
    fi
    
    python3 ../getorder.py <Repo_spec.txt.dagchainer.aligncoords > order.txt
    python3 ../reconf.py order.txt old_config.txt > SynIma-output/config.txt
    
    perl ../../SynIma.pl -a Repo_spec.txt.dagchainer.aligncoords \
                 -b Repo_spec.txt.dagchainer.aligncoords.spans
}
