#!/usr/bin/env python3

import sys
import pygg
import pandas as pd
import statistics as st

def get_data(data_type, data_bed, chrlen_bed, offset):
    data = pd.read_csv(data_bed, sep="\t", header=None)
    print(data)
    data.columns = ["Scaffold", "Start", "End", "Density"]

    chrlens = pd.read_csv(chrlen_bed, sep="\t", header=None)
    chrlens.columns = ["chrom", "len", "index", "index_1", "cumsum"]

    chr_rank_dict = {}
    for index, row in chrlens.iterrows():
        chr_rank_dict[row["chrom"]] = row["index_1"]

    chr_lens_dict = {}
    for index, row in chrlens.iterrows():
        chr_lens_dict[row["chrom"]] = row["len"]

    cumsum_dict = {}
    for index, row in chrlens.iterrows():
        chr_lens_dict[row["chrom"]] = row["cumsum"]

    data["Scaffold_number"] = data["Scaffold"].replace(chr_rank_dict)
    data["sort_index"] = data["Scaffold_number"] * 1e12 + data["Start"]
    data.sort_values(by="sort_index", inplace=True)
    data["chrlen"] = data["Scaffold"].replace(chr_lens_dict)
    data["cumsum"] = data["Scaffold"].replace(chr_lens_dict)
    data["plotpos"] = data["Scaffold_number"] * offset + data["cumsum"] + data["Start"]
    data["true_density"] = data["Density"] / 1000000.0
    data["Feature"] = data_type
    return(data)

def combine_data(data1, data2):
    return(pd.concat([data1, data2]))

def unmelt_combo(combo):
    temp = combo.copy(deep=True)
    indices = ((a, b) for a,b in zip(temp["Scaffold_number"], temp["Start"]))
    temp["index"] = list(indices)
    minitemp = temp[["index", "Feature", "true_density"]]
    print(minitemp)
    out = minitemp.pivot(index = "index", columns = "Feature")
    return(out)

def correlate_combo(combo_unmelted):
    return(combo_unmelted.corr())

def covmat_combo(combo_unmelted):
    return(combo_unmelted.cov())

def main():
    offset = 5000000
    genedata = get_data("Genes", "answer_dens.bed", "reflens.txt", offset)
    repdata = get_data("Repeats", "family_densities/repanswer_family_Simple_repeat_dens.bed", "reflens.txt", offset)
    combo = combine_data(genedata, repdata)
    print(combo.head())
    combo_unmelted = unmelt_combo(combo)
    print(combo_unmelted.head())
    corr = correlate_combo(combo_unmelted)
    print(corr)
    cov = covmat_combo(combo_unmelted)
    print(cov)
    

if __name__ == "__main__":
    main()
