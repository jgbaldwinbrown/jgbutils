#!/usr/bin/env python3

import sys

def main():
    inbedpath = sys.argv[1]
    indexpath = sys.argv[2]
    for i, ls in enumerate(zip(open(inbedpath, "r"), open(indexpath, "r"))):
        bedl = ls[0].rstrip('\n')
        bedsl = bedl.split('\t')
        indl = ls[1].rstrip('\n')
        indsl = indl.split('\t')
        if indsl[1] == "PASS":
            print("\t".join(bedsl[:3]))

if __name__ == "__main__":
    main()


#for i in ./haplocaller_200ploid/out2.txt ./haplocaller_2ploid/out2.txt ./samtools_popoolation/sync2freq2.txt
#j=old_correct/snpsfile_12pop_degs.txt
#./haplocaller_200ploid/degs_snpsfile_cens_index.txt
#./haplocaller_200ploid/full_snpsfile_cens_index.txt
#./haplocaller_2ploid/full_snpsfile_cens_index.txt
#./haplocaller_2ploid/degs_snpsfile_cens_index.txt
#./old_correct/full_snpsfile_cens_index.txt
#./old_correct/degs_snpsfile_cens_index.txt
#./samtools_popoolation/full_snpsfile_cens_index.txt
#./samtools_popoolation/degs_snpsfile_cens_index.txt

#    bedified = outprefix + ".input.bedified.bed"
#degs_ld.input.bedified.bed

#Backbone_105/0_36014|quiver|quiver|quiver	9250	9251	4	Backbone_105/0_36014|quiver|quiver|quiver	9251	A	C	0.00000000	2	0.00000000	2	0.00000000	1	0.00000000	2	0.00000000	1	NA	0	NA	0	0.00000000	2	0.00000000	2	NA	0	0.00000000	1	NA	0
#Backbone_105/0_36014|quiver|quiver|quiver	9251	9252	4	Backbone_105/0_36014|quiver|quiver|quiver	9252	C	A	0.00000000	2	0.00000000	2	0.00000000	1	0.00000000	2	0.00000000	1	NA	0	NA	0	0.00000000	2	0.00000000	2	NA	0	0.00000000	1	NA	0
#Backbone_105/0_36014|quiver|quiver|quiver	9262	9263	4	Backbone_105/0_36014|quiver|quiver|quiver	9263	C	T	0.33333333	3	0.00000000	3	1.00000000	1	0.50000000	2	0.00000000	1	NA	0	NA	0	0.00000000	3	0.40000000	5	NA	0	1.00000000	1	NA	0
#Backbone_105/0_36014|quiver|quiver|quiver	9285	9286	1	Backbone_105/0_36014|quiver|quiver|quiver	9286	TA	T	0.00000000	10	0.00000000	4	0.00000000	6	0.00000000	4	0.00000000	3	0.00000000	4	0.00000000	3	0.00000000	8	0.00000000	12	NA	0	0.00000000	3	0.00000000	6
