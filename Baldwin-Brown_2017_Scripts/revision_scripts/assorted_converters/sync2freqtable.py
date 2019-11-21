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

def print_header(ncalls):
    out = ['"Nmiss"', '"CHROM"', '"POS"', '"REF"', '"ALT"']
    for i in range(ncalls):
        num = str(700 + i)
        out.append('"freq_JBB_hb' + num + '_Lcombo"')
        out.append('"N_JBB_hb' + num + '_Lcombo"')
    print("\t".join(map(str, out)))
#"Nmiss" "CHROM" "POS" "REF" "ALT" "freq_JBB_hb701_Lcombo" "N_JBB_hb701_Lcombo" "freq_JBB_hb702_Lcombo" "N_JBB_hb702_Lcombo" "freq_JBB_hb703_Lcombo" "N_JBB_hb703_Lcombo" "freq_JBB_hb704_Lcombo" "N_JBB_hb704_Lcombo" "freq_JBB_hb705_Lcombo" "N_JBB_hb705_Lcombo" "freq_JBB_hb706_Lcombo" "N_JBB_hb706_Lcombo" "freq_JBB_hb707_Lcombo" "N_JBB_hb707_Lcombo" "freq_JBB_hb708_Lcombo" "N_JBB_hb708_Lcombo" "freq_JBB_hb709_Lcombo" "N_JBB_hb709_Lcombo" "freq_JBB_hb710_Lcombo" "N_JBB_hb710_Lcombo" "freq_JBB_hb711_Lcombo" "N_JBB_hb711_Lcombo" "freq_JBB_hb712_Lcombo" "N_JBB_hb712_Lcombo" "totcov"

def print_locus(calls, refcol, altcol, chrom, pos):
    out = ['"0"', "0", '"' + str(chrom) + '"', '"' + str(pos) + '"']
    ident = ["A","T","G","C","N","0"]
    ref = ident[refcol]
    alt = ident[altcol]
    out.append('"' + ref + '"')
    out.append('"' + alt + '"')
    big_tot = 0
    for call in calls:
        tot = call[refcol] + call[altcol]
        big_tot += tot
        try:
            freq = float(call[refcol]) / float(tot)
        except ZeroDivisionError:
            freq = 0.0
        out.append(str(freq))
        out.append(str(tot))
    out.append(str(big_tot))
    print("\t".join(map(str, out)))

def main():
    ident = ["a","t","g","c","n","0"]
    for i, l in enumerate(fileinput.input()):
        sl = l.rstrip('\n').split('\t')
        chrom = sl[0]
        pos = int(sl[1])
        ref_allele = sl[2].lower()
        calls = [list(map(int, x.split(":"))) for x in sl[3:]]
        if i == 0:
            ncalls = len(calls)
            print_header(ncalls)
        refcol = ident.index(ref_allele)
        colcounts = count_cols(calls)
        altcol = get_alt_col(colcounts, refcol)
        majmin = get_maj_and_min_cols(colcounts)
        if majmin[0] < 4 and majmin[1] < 4 and colcounts[majmin[0]] > 0 and colcounts[majmin[1]] > 0:
            print_locus(calls, majmin[0], majmin[1], chrom, pos)
    
if __name__ == "__main__":
    main()

#"Nmiss" "CHROM" "POS" "REF" "ALT" "freq_JBB_hb701_Lcombo" "N_JBB_hb701_Lcombo" "freq_JBB_hb702_Lcombo" "N_JBB_hb702_Lcombo" "freq_JBB_hb703_Lcombo" "N_JBB_hb703_Lcombo" "freq_JBB_hb704_Lcombo" "N_JBB_hb704_Lcombo" "freq_JBB_hb705_Lcombo" "N_JBB_hb705_Lcombo" "freq_JBB_hb706_Lcombo" "N_JBB_hb706_Lcombo" "freq_JBB_hb707_Lcombo" "N_JBB_hb707_Lcombo" "freq_JBB_hb708_Lcombo" "N_JBB_hb708_Lcombo" "freq_JBB_hb709_Lcombo" "N_JBB_hb709_Lcombo" "freq_JBB_hb710_Lcombo" "N_JBB_hb710_Lcombo" "freq_JBB_hb711_Lcombo" "N_JBB_hb711_Lcombo" "freq_JBB_hb712_Lcombo" "N_JBB_hb712_Lcombo" "totcov"
#"500" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 32433 "G" "A" 0.93 60 1 10 0.94 50 0.78 37 1 51 1 36 0.94 250 0.19 37 0.69 77 0.7 43 0.59 250 1 26 927
#"502" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 32648 "A" "T" 0.96 47 1 10 0.96 54 0.77 22 1 33 1 38 0.88 198 0.07 46 0.48 56 0.5 32 0.52 250 1 11 797
#"503" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 32814 "T" "C" 0.8 41 1 16 0.62 40 0.83 23 1 28 1 35 0.85 194 0.33 40 0.55 60 0.4 30 0.26 209 1 19 735
#"504" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 32994 "G" "A" 0.89 36 1 12 0.45 20 0.75 24 1 14 1 35 0.84 152 0.34 41 0.4 75 0.47 19 0.44 205 1 10 643
#"505" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 33040 "A" "G" 0.65 31 1 11 0.73 26 0.5 20 1 20 1 28 0.84 141 0.27 30 0.3 69 0.54 26 0.35 215 1 14 631
#"506" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 33050 "C" "T" 0.85 34 1 11 0.74 27 0.44 18 1 19 1 32 0.85 149 0.23 35 0.32 69 0.56 27 0.39 217 1 14 652
#"510" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 34036 "T" "A" 0.97 67 1 19 0.91 56 0.76 34 0.24 38 0.45 71 0.78 231 1 50 0.77 105 0.82 40 0.76 232 1 15 958
#"511" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 34089 "G" "C" 0.78 59 0.55 20 0.47 59 1 43 0.93 42 1 73 1 245 1 53 0.95 101 1 39 1 249 0.53 17 1000
#"515" 0 "Backbone_102/0_263521|quiver|quiver|quiver" 34682 "A" "C" 0 41 0 14 0 46 0.37 30 0 37 0 28 0.13 159 0.07 14 0.09 100 0.46 39 0.04 131 0 17 656

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
