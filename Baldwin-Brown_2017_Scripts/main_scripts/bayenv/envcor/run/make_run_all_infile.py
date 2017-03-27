#!/bin/bash

numpops_array=["11"]

scheme_array=["standard"]

mode_array=["nonparametric","pooled"]

poly_type=["Indel","SNP"]

snpsfiles=["/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/data/snpsfiles_deduped2/dsbigs_fused/only-PASS-Q30-INDEL-cov_v2_ds_7_11_v1_fused_snpsfile.txt",
"/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/data/snpsfiles_deduped2/dsbigs_fused/only-PASS-Q30-SNPS-cov_v2_ds_7_11_v1_fused_snpsfile.txt"]

envfiles=["/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/envfile/normalized_transposed_tank_info_11pop.txt",
"/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/envfile/normalized_transposed_tank_info.txt"]

envfilesplitprefixes=["/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/envfile/split/11pop/splitenvfile_11pop",
"/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/envcor/v2/envfile/split/12pop/splitenvfile_12pop"]

matfiles=["/bio/jbaldwi1/all_data_from_dfs2/shrimp_data/bayenv/scripts/cov_mat_generation/v2_deduped/dsbigs_fused/standard/11pop/shrimp_matrix_11_standard_final.txt"]

pooledmatfiles=matfiles

print "\t".join(["numpops","scheme","bayenv_mode","polymorphism_type","envfile_to_use","envfile_prefix_to_use","matfile_to_use","snpsfile_to_use","pooled_matfile_to_use"])

for np in enumerate(numpops_array):
    for s in enumerate(scheme_array):
        for m in enumerate(mode_array):
            for p in enumerate(poly_type):
                outlist=[]
                outlist.append(np[1])
                outlist.append(s[1])
                outlist.append(m[1])
                outlist.append(p[1])
                outlist.append(envfiles[np[0]])
                outlist.append(envfilesplitprefixes[np[0]])
                matindex=s[0]*2 + np[0]
                outlist.append(matfiles[matindex])
                snpindex=s[0]*4+np[0]*2+p[0]
                outlist.append(snpsfiles[snpindex])
                outlist.append(pooledmatfiles[matindex])
                if not "pooled" in outlist: print "\t".join(map(str,outlist))

