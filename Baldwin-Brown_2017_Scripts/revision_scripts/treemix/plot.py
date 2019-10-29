#!/usr/bin/env python3

from Bio import Phylo
from matplotlib import pyplot as plt

# # only import the below if using draw_graphviz:
# import pygraphviz

tree = Phylo.read("out.treeout", "newick")
# print(str(tree))
Phylo.draw(tree, do_show=False)
plt.savefig("out.pdf")

# # the below draws an unrooted tree with graphviz; this is deprecated because branch lengths aren't accurate:
# Phylo.draw_graphviz(tree)
