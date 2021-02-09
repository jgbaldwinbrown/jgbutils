#!/usr/bin/env python3

import sys

def get_data(inconn):
    out = {}
    for l in inconn:
        if l[0] == "#":
            continue
        l = l.rstrip('\n').split('\t')
        if len(l) < 13:
            continue
        chrom = l[8]
        if not chrom in out:
            out[chrom] = []
        out[chrom].append([
            l[1],
            int(l[3]),
            int(l[4]),
            int(l[5]),
            l[8],
            int(l[10]),
            int(l[11]),
            int(l[12]),
        ])
    return(out)

def subset_hits(data):
    out = {}
    for pchrom_name, pchrom_data in data.items():
        entry = pchrom_data[0]
        if entry[0] not in out:
            out[entry[0]] = []
        out[entry[0]].append(entry)
    return(out)

def order_hits(subset):
    out = {}
    for cchrom_name, cchrom_data in subset.items():
        out[cchrom_name] = sorted(cchrom_data, key=lambda x:x[2])
    return(out)

def listify_hits(ordered):
    out = []
    for cchrom_name, cchrom_data in ordered.items():
        chromnum = int(cchrom_name.split('_')[2])
        out.append([chromnum, cchrom_name, cchrom_data])
        out.sort(key = lambda x: x[0])
    return(out)

def write_hits(data, outconn):
    for chrom in data:
        for entry in chrom[2]:
            outconn.write("\t".join(map(str, entry)) + "\n")

def main():
    data = get_data(sys.stdin)
    subsetted = subset_hits(data)
    ordered = order_hits(subsetted)
    listified = listify_hits(ordered)
    write_hits(listified, sys.stdout)

if __name__ == "__main__":
    main()

# ## alignment ccolumbae;PGA_scaffold_10__92_contigs__length_14329688 vs. phumanus;DS235028 Alignment #1  score = 9.0 (num aligned pairs: 4):
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-25.24-mRNA-1	2570050	2567645	242	MATCHES	phumanus	DS235028	phumanus:transcript:PHUM060130-RA	207054	205341	18	1e-50	3.0
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-25.25-mRNA-1	2583443	2572499	243	MATCHES	phumanus	DS235028	phumanus:transcript:PHUM060140-RA	212557	208333	19	1e-50	6.0
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-26.84-mRNA-1	2589876	2587278	244	MATCHES	phumanus	DS235028	phumanus:transcript:PHUM060150-RA	222624	221026	20	1e-50	9.0
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-26.46-mRNA-1	2596079	2602470	248	MATCHES	phumanus	DS235028	phumanus:transcript:PHUM060160-RA	223723	231003	21	1e-50	9.0
# ## alignment ccolumbae;PGA_scaffold_10__92_contigs__length_14329688 vs. phumanus;DS235047 Alignment #1  score = 6.0 (num aligned pairs: 2):
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-77.82-mRNA-1	7731961	7726009	610	MATCHES	phumanus	DS235047	phumanus:transcript:PHUM079800-RA	14499	16171	2	1e-50	3.0
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:augustus_masked-PGA_scaffold_10__92_contigs__length_14329688-processed-gene-77.30-mRNA-1	7733326	7734150	611	MATCHES	phumanus	DS235047	phumanus:transcript:PHUM079810-RA	17185	16355	3	1e-50	6.0
# ## alignment ccolumbae;PGA_scaffold_10__92_contigs__length_14329688 vs. phumanus;DS235047 (reverse) Alignment #1  score = 57.0 (num aligned pairs: 23):
# ccolumbae	PGA_scaffold_10__92_contigs__length_14329688	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-75.14-mRNA-1	7533357	7540758	578	MATCHES	phumanus	DS235047	phumanus:transcript:PHUM080140-RA	152065	150532	26	1e-50	3.0



#      0  ccolumbae
#      1	PGA_scaffold_10__92_contigs__length_14329688
#      2	ccolumbae:maker-PGA_scaffold_10__92_contigs__length_14329688-augustus-gene-25.24-mRNA-1
#      3	2570050
#      4	2567645
#      5	242
#      6	MATCHES
#      7	phumanus
#      8	DS235028
#      9	phumanus:transcript:PHUM060130-RA
#     10	207054
#     11	205341
#     12	18
#     13	1e-50
#     14	3.0
