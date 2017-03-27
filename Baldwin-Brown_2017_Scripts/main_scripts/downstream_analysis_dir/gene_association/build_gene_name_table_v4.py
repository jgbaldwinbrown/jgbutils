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
        self.go_terms = []
        self.summary = "unknown"
        self.gene_name = "unknown"
    def print_all(self):
        shrimp_genes = ["unknown"] if len(self.shrimp_genes) == 0 else self.shrimp_genes
        dmel_to_shrimp_genes = ["unknown"] if len(self.dmel_to_shrimp_genes) == 0 else self.dmel_to_shrimp_genes
        mutual_best_hits = ["unknown"] if len(self.mutual_best_hits) == 0 else self.mutual_best_hits
        go_terms = ["unknown"] if len(self.go_terms) == 0 else self.go_terms
        outlist = [self.fbgn, self.fbtr, self.fbpp, self.gene_name, ";".join(shrimp_genes), ";".join(dmel_to_shrimp_genes), ";".join(mutual_best_hits), ";".join(go_terms),self.summary]
        print "\t".join(outlist)

def print_header():
    outlist = ["FBgn", "FBtr", "FBpp", "gene_name", "shrimp_to_dmel_genes", "dmel_to_shrimp_genes", "mutual_best_hits", "go_terms", "summary"]
    print "\t".join(outlist)

fbgn_table_file = "gene_association/fbgn_fbtr_fbpp_table/fbgn_fbtr_fbpp_fb_2016_04.tsv.gz"
go_table_file = "gene_association/go_data/gene_association.fb.gz"
gene_info_file = "gene_association/other/gene_summaries.tsv.gz"
shrimp_blast_file = "gene_association/shrimp_augustus_prot_queried_on_dmel_prot"
dmel_to_shrimp_blast_file = "gene_association/dmel_prot_queried_on_shrimp_augustus_prot"

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

for key,mygene in data.iteritems():
    mygene.mutual_best_hits = list(set(mygene.shrimp_genes) & set(mygene.dmel_to_shrimp_genes))

print_header()
for key,mygene in data.iteritems():
    mygene.print_all()

