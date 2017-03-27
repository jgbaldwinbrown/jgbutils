import sys
import gzip

class gene(object):
    def __init__(self):
        self.fbgn = "unknown"
        self.fbtr = "unknown"
        self.fbpp = "unknown"
        self.shrimp_genes = []
        self.dmel_to_shrimp_genes = []
        self.mutual_best_hits = []
        self.is_de = "unknown"
        self.is_de_hi = "unknown"
        self.de_padj = "unknown"
        self.go_terms = []
        self.summary = "unknown"
        self.gene_name = "unknown"
    def print_all(self):
        shrimp_genes = ["unknown"] if len(self.shrimp_genes) == 0 else self.shrimp_genes
        dmel_to_shrimp_genes = ["unknown"] if len(self.dmel_to_shrimp_genes) == 0 else self.dmel_to_shrimp_genes
        mutual_best_hits = ["unknown"] if len(self.mutual_best_hits) == 0 else self.mutual_best_hits
        go_terms = ["unknown"] if len(self.go_terms) == 0 else self.go_terms
        outlist = [self.fbgn, self.fbtr, self.fbpp, self.gene_name, ";".join(shrimp_genes), ";".join(dmel_to_shrimp_genes), ";".join(mutual_best_hits), self.is_de, self.is_de_hi, str(self.de_padj), ";".join(go_terms),self.summary]
        print "\t".join(outlist)

def print_header():
    outlist = ["FBgn", "FBtr", "FBpp", "gene_name", "shrimp_to_dmel_genes", "dmel_to_shrimp_genes", "mutual_best_hits", "differentially_expressed", "differentially_expressed_hisig", "differential_expression_padj", "go_terms", "summary"]
    print "\t".join(outlist)

fbgn_table_file = "gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz"
go_table_file = "gene_association/go_data/gene_association.fb.gz"
gene_info_file = "gene_association/other/gene_summaries.tsv.gz"
shrimp_blast_file = "gene_association/shrimp_augustus_prot_queried_on_dmel_prot"
dmel_to_shrimp_blast_file = "gene_association/dmel_prot_queried_on_shrimp_augustus_prot"
shrimp_gff_file = "gene_association/shrimp_augustus_all_10-12-15.gff3.gz"
de_gene_file = "gene_association/clam_shrimp_deseq_hiselec_genes_bigOutFilt_allselec.txt"
de_gene_file_nosig = "gene_association/clam_shrimp_deseq_hiselec_genes_bigOutFilt.txt"


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
for key,mygene in data.iteritems():
    mygene.mutual_best_hits = list(set(mygene.shrimp_genes) & set(mygene.dmel_to_shrimp_genes))
    if len(mygene.mutual_best_hits) == 1:
        #sys.stderr.write(str(mygene.mutual_best_hits)+"\n")
        gene_name = "".join(mygene.mutual_best_hits[0].split(".")[:-1])
        trans_name = mygene.mutual_best_hits[0]
        sg2fbgn[gene_name] = mygene.fbgn
        st2fbgn[trans_name] = mygene.fbgn

#for line in gzip.open(shrimp_gff_file,"r"):
#    line = line.rstrip('\n')
#    sline = line.split('\t')
#    if line[0] == "#" or len(sline) != 9:
#        print line
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
#    print "\t".join(map(str,out))

#sys.stderr.write(str(sg2fbgn) + "\n")
for entry in enumerate(open(de_gene_file,"r")):
    line = entry[1].rstrip('\n')
    (rname, gname, baseMean, baseMeanA, baseMeanB, foldChange, log2FoldChange, pval, padj, herm, male, passed) = line.split()
    gname2 = gname.strip('"').replace(".","")
    #sys.stderr.write(gname2+'\n')
    if gname2 in sg2fbgn:
        #sys.stderr.write('good\n')
        myfbgn = sg2fbgn[gname2]
        if myfbgn in data:
            #sys.stderr.write('in_data\n')
            data[myfbgn].is_de = "True"
    
for entry in enumerate(open(de_gene_file_nosig,"r")):
    if entry[0] == 0:
        continue
    line = entry[1].rstrip('\n')
    (rname, gname, baseMean, baseMeanA, baseMeanB, foldChange, log2FoldChange, pval, padj, herm, male) = line.split()
    gname2 = gname.strip('"').replace(".","")
    #sys.stderr.write(gname2+'\n')
    if gname2 in sg2fbgn:
        #sys.stderr.write('good\n')
        myfbgn = sg2fbgn[gname2]
        if myfbgn in data:
            #sys.stderr.write('in_data\n')
            data[myfbgn].de_padj = float(padj)

print_header()
for key,mygene in data.iteritems():
#    if mygene.is_de == "True":
        mygene.print_all()

sdata = []
for i in data.itervalues():
    if i.de_padj != "unknown":
        sdata.append(i)
sdata = sorted(sdata,key=lambda x: x.de_padj)

with open("de_ranked_genes.txt","w") as file:
    for i in sdata:
        file.write(str(i.fbgn)+"\n")

