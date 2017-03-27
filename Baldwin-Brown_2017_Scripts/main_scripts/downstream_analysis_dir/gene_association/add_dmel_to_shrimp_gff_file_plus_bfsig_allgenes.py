import sys
import gzip

args = sys.argv
bfind = args[1]

class gene(object):
    def __init__(self):
        self.fbgn = "unknown"
        self.fbtr = "unknown"
        self.fbpp = "unknown"
        self.shrimp_genes = []
        self.dmel_to_shrimp_genes = []
        self.mutual_best_hits = []
        self.go_terms = []
        self.summary = "unknown"
        self.gene_name = "unknown"
        self.hit_extents = []
    def print_all(self):
        shrimp_genes = ["unknown"] if len(self.shrimp_genes) == 0 else self.shrimp_genes
        dmel_to_shrimp_genes = ["unknown"] if len(self.dmel_to_shrimp_genes) == 0 else self.dmel_to_shrimp_genes
        mutual_best_hits = ["unknown"] if len(self.mutual_best_hits) == 0 else self.mutual_best_hits
        go_terms = ["unknown"] if len(self.go_terms) == 0 else self.go_terms
        outlist = [self.fbgn, self.fbtr, self.fbpp, self.gene_name, ";".join(shrimp_genes), ";".join(dmel_to_shrimp_genes), ";".join(mutual_best_hits), ";".join(go_terms),self.summary]
        print "\t".join(map(str,outlist))

class snp(object):
    def __init__(self):
        self.name = "unknown"
        self.chrom = "unknown"
        self.pos = "unknown"
        self.bf = "unknown"
        self.bfhits_sg = []
        self.bfhits_fbgn = []
    def print_all(self):
        outlist = [self.name,self.chrom,self.pos,self.bf,unk_list(self.bfhits_sg),unk_list(self.bfhits_fbgn)]
        print "\t".join(map(str,outlist))

def unk_list(alist):
    outlist =  ["unknown"] if len(alist) == 0 else alist
    return ";".join(map(str,outlist))

def print_header():
    outlist = ["FBgn", "FBtr", "FBpp", "gene_name", "shrimp_to_dmel_genes", "dmel_to_shrimp_genes", "mutual_best_hits", "go_terms", "summary"]
    print "\t".join(outlist)

def print_snp_header():
    outlist = ["snp_name","chrom","pos","XtX_score","shrimp_genes_hit_bf","dmel_genes_hit_bf"]
    print "\t".join(outlist)

def rreplace(s, old, new, occurrence):
    li = s.rsplit(old, occurrence)
    return new.join(li)

fbgn_table_file = "gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz"
go_table_file = "gene_association/go_data/gene_association.fb.gz"
gene_info_file = "gene_association/other/gene_summaries.tsv.gz"
shrimp_blast_file = "gene_association/shrimp_augustus_prot_queried_on_dmel_prot"
dmel_to_shrimp_blast_file = "gene_association/dmel_prot_queried_on_shrimp_augustus_prot"
shrimp_gff_file = "gene_association/shrimp_augustus_all_10-12-15.gff3.gz"
pop11_snp_table = "gene_association/snp_table/11pop_deduped/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused.txt"
bf_sig_table = "gene_association/mean_bf_environ.normalized_transposed_tank_info_11pop_bfsigfilter.txt." + str(bfind)

data = {}
pp2gn = {}
tr2gn = {}
for entry in enumerate(gzip.open(fbgn_table_file,"r")):
    if entry[0] <= 5:
        continue
    sline = entry[1].rstrip('\n').split()
    #print sline
    if len(sline) >= 2:
        myfbgn = sline[0]
        myfbtr = sline[1]
        try:
            myfbpp = sline[2]
        except IndexError:
            myfbpp= "unknown"
    data[myfbgn] = gene()
    data[myfbgn].fbgn = myfbgn
    data[myfbgn].fbtr = myfbtr
    data[myfbgn].fbpp = myfbpp
    
    pp2gn[myfbpp] = myfbgn
    tr2gn[myfbtr] = myfbgn

for entry in enumerate(gzip.open(go_table_file,"r")):
    if entry[1][0] == "!":
        continue
    sline = entry[1].rstrip('\n').split()
    if sline[0] in data:
        data[sline[0]].go_terms.append("`".join(sline))

for entry in enumerate(gzip.open(gene_info_file,"r")):
    if entry[1][0] == "#":
        continue
    sline = entry[1].rstrip('\n').split()
    if sline[0] in data:
        data[sline[0]].go_terms.append("_".join(sline[1:]))

for line in open(shrimp_blast_file,"r"):
    (queryId, subjectId, percIdentity, alnLength, mismatchCount, gapOpenCount, queryStart, queryEnd, subjectStart, subjectEnd, eVal, bitScore) = line.split("\t")
    if subjectId in pp2gn:
        myfbgn = pp2gn[subjectId]
        if myfbgn in data:
            data[myfbgn].shrimp_genes.append(queryId)

for line in open(dmel_to_shrimp_blast_file,"r"):
    (queryId, subjectId, percIdentity, alnLength, mismatchCount, gapOpenCount, queryStart, queryEnd, subjectStart, subjectEnd, eVal, bitScore) = line.split("\t")
    if queryId in pp2gn:
        myfbgn = pp2gn[queryId]
        if myfbgn in data:
            data[myfbgn].dmel_to_shrimp_genes.append(subjectId)

sg2fbgn = {}
st2fbgn = {}
sgv2_2_fbgn = {}
for key,mygene in data.iteritems():
    mygene.mutual_best_hits = list(set(mygene.shrimp_genes) & set(mygene.dmel_to_shrimp_genes))
    if len(mygene.mutual_best_hits) == 1:
        #sys.stderr.write(str(mygene.mutual_best_hits)+"\n")
        gene_name = "".join(mygene.mutual_best_hits[0].split(".")[:-1])
        trans_name = mygene.mutual_best_hits[0]
        sg2fbgn[gene_name] = mygene.fbgn
        st2fbgn[trans_name] = mygene.fbgn
        gene_name_v2 = rreplace(gene_name,"g",".g",1)
        sgv2_2_fbgn[gene_name_v2] = mygene.fbgn
        #print "\t".join([gene_name,mygene.fbgn])

#for line in gzip.open(shrimp_gff_file,"r"):
#    line = line.rstrip('\n')
#    sline = line.split('\t')
#    if line[0] == "#" or len(sline) != 9:
#        #print line
#        continue
#    fields = sline[8].split(";")
#    myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
#    myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
#    myfbgn = ""
#    if len(myid) > 0:
#        if myid[0][1] in sg2fbgn:
#            myfbgn = sg2fbgn[myid[0][1]]
#        if myid[0][1] in st2fbgn:
#            myfbgn = st2fbgn[myid[0][1]]
#    if len(myparent) > 0:
#        if myparent[0][1] in sg2fbgn:
#            myfbgn = sg2fbgn[myparent[0][1]]
#        if myparent[0][1] in st2fbgn:
#            myfbgn = st2fbgn[myparent[0][1]]
#    if len(myfbgn) > 0:
#        fields.append("fly_FBgn="+str(myfbgn))
#    out = sline[:-1]
#    out.append(";".join(map(str,fields)))
#    #print "\t".join(map(str,out))

#for line in gzip.open(shrimp_gff_file,"r"):
#    line = line.rstrip('\n')
#    sline = line.split('\t')
#    if line[0] == "#" or len(sline) != 9 or sline[2] != "gene":
#        continue
#    fields = sline[8].split(";")
#    myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
#    myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
#    mychrom = sline[0]
#    mystart = float(sline[3])
#    myend = float(sline[4])
#    myfbgn = ""
#    #print str(myid)
#    #print str(mychrom)
#    #print str(mystart)
#    #print str(myend)
#    #print str(myid[0][1] in sg2fbgn)
#    if len(myid) > 0:
#        if myid[0][1] in sgv2_2_fbgn:
#            myfbgn = sgv2_2_fbgn[myid[0][1]]
#    if len(myfbgn) > 0:
#        fields.append("fly_FBgn="+str(myfbgn))
#        data[myfbgn].hit_extents.append([myid[0][1],mychrom,mystart,myend])
#        #print "\t".join(map(str,data[myfbgn].hit_extents))

anonindex=0
for line in gzip.open(shrimp_gff_file,"r"):
    line = line.rstrip('\n')
    sline = line.split('\t')
    if line[0] == "#" or len(sline) != 9 or sline[2] != "gene":
        continue
    fields = sline[8].split(";")
    myid=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "ID=" in v]
    myparent=[(i,v.split("=")[-1]) for i,v in enumerate(fields) if "Parent=" in v]
    mychrom = sline[0]
    mystart = float(sline[3])
    myend = float(sline[4])
    myfbgn = ""
    #print str(myid)
    #print str(mychrom)
    #print str(mystart)
    #print str(myend)
    #print str(myid[0][1] in sg2fbgn)
    if len(myid) > 0:
        if myid[0][1] in sgv2_2_fbgn:
            myfbgn = sgv2_2_fbgn[myid[0][1]]
    if len(myfbgn) > 0:
        fields.append("fly_FBgn="+str(myfbgn))
        data[myfbgn].hit_extents.append([myid[0][1],mychrom,mystart,myend])
        #print "\t".join(map(str,data[myfbgn].hit_extents))
    else:
        fields.append("fly_FBgn=none")
        data[anonindex] = gene()
        data[anonindex].hit_extents.append([myid[0][1],mychrom,mystart,myend])
        anonindex = anonindex + 1


#print "split0"

snpindex = 0
snps = {}
for entry in enumerate(open(pop11_snp_table,"r")):
    if entry[0] == 0:
        continue
    line = entry[1]
    sline = line.rstrip('\n').split()
    snpname = "s"+str(snpindex)
    chrom = sline[1]
    pos = sline[2]
    #print snpname
    #print chrom
    #print pos
    snps[snpname] = snp()
    snps[snpname].name = snpname
    snps[snpname].chrom = chrom
    snps[snpname].pos = float(pos)
    snpindex += 1
    #snps[snpname].print_all()

#print("split1")
for line in open(bf_sig_table,"r"):
    if "Passed" not in line:
        continue
    sline = line.rstrip('\n').split()
    name = sline[0]
    score = sline[1]
    snps[name].bf = score
    #print name
    #print score
    #snps[name].print_all()
    for genekey,gene in data.iteritems():
        for hit in gene.hit_extents:
            #print snps[name]
            #print hit[1]
            #print hit[2]
            #print hit[3]
            if hit[1] == snps[name].chrom and hit[2] - 5000 <= snps[name].pos <= hit[3] + 5000:
                snps[name].bfhits_sg.append(hit[0])
                #snps[name].bfhits_fbgn.append(sgv2_2_fbgn[hit[0]])
                try:
                    snps[name].bfhits_fbgn.append(sgv2_2_fbgn[hit[0]])
                except KeyError:
                    pass
    #debug:
    #snps[name].print_all()
    

print_snp_header()
for key,mysnp in snps.iteritems():
    if len(mysnp.bfhits_sg) > 0 or len(mysnp.bfhits_fbgn) > 0:
        mysnp.print_all()

#print_header()
#for key,mygene in data.iteritems():
#    mygene.print_all()


