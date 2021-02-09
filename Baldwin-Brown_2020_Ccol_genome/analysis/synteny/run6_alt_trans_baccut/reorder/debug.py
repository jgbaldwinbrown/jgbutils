#!/usr/bin/env python3

import sys
import getorder


def main():
    with open(sys.argv[1], "r") as inconn:
        data = getorder.get_data(inconn)
    subsetted = getorder.subset_hits(data)
    ordered = getorder.order_hits(subsetted)
    listified = getorder.listify_hits(ordered)
    getorder.write_hits(listified, sys.stdout)

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
