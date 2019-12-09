#!/usr/bin/env python3

import fileinput

def count_cols(calls):
    counts = [0,0,0,0,0,0]
    for call in calls:
        for i, col in enumerate(call):
            counts[i] += col
    return(counts)

def get_alt_col(colcounts, refcol):
    largest = -1
    largestval = -1
    second = -1
    secondval = -1
    for i, count in enumerate(colcounts):
        if count > largestval:
            secondval = largestval
            second = largest
            largestval = count
            largest = i
        elif count > secondval:
            secondval = count
            second = i
    if largest == refcol:
        return(second)
    else:
        return(largest)

def get_maj_and_min_cols(colcounts):
    largest = -1
    largestval = -1
    second = -1
    secondval = -1
    for i, count in enumerate(colcounts):
        if count > largestval:
            secondval = largestval
            second = largest
            largestval = count
            largest = i
        elif count > secondval:
            secondval = count
            second = i
    return((largest, second))

def print_locus(calls, refcol, altcol):
    out = []
    for call in calls:
        out.append(call[refcol])
        out.append(call[altcol])
    print("\t".join(map(str, out)))

def main():
    ident = ["a","t","g","c","n","0"]
    for l in fileinput.input():
        sl = l.rstrip('\n').split('\t')
        chrom = sl[0]
        pos = int(sl[1])
        ref_allele = sl[2].lower()
        calls = [list(map(int, x.split(":"))) for x in sl[3:]]
        refcol = ident.index(ref_allele)
        colcounts = count_cols(calls)
        altcol = get_alt_col(colcounts, refcol)
        majmin = get_maj_and_min_cols(colcounts)
        if majmin[0] < 4 and majmin[1] < 4 and colcounts[majmin[0]] > 0 and colcounts[majmin[1]] > 0:
            print_locus(calls, majmin[0], majmin[1])
    
if __name__ == "__main__":
    main()

# Backbone_110/0_10251|quiver|quiver|quiver	13	a	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	1:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	14	t	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:1:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	15	c	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:1:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	16	g	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:1:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	17	t	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:2:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	18	c	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:2:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	19	c	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:2:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	20	t	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:2:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	21	t	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:2:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
# Backbone_110/0_10251|quiver|quiver|quiver	22	t	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:2:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0	0:0:0:0:0:0
