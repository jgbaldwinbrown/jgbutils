#!/usr/bin/env python3

from Bio import Phylo
from matplotlib import pyplot as plt

import sys

# # only import the below if using draw_graphviz:
# import pygraphviz

inpath = sys.argv[1]
outpath = sys.argv[2]

tree = Phylo.read(inpath, "newick")
# print(str(tree))
Phylo.draw(tree, do_show=False)
plt.savefig(outpath, format='png')

# # the below draws an unrooted tree with graphviz; this is deprecated because branch lengths aren't accurate:
# Phylo.draw_graphviz(tree)
