#!/usr/bin/env python3

import sys
import pygg
import pandas as pd
import statistics as st

def get_mid(chromdata_single):
    return(st.mean([chromdata_single["plotpos"].min(), chromdata_single["plotpos"].max()]))

def get_chrom_mids(chromdata, offset):
    chroms = chromdata["Scaffold_number"].unique()
    outframe = pd.DataFrame({"Scaffold_number": chroms})
    mids = []
    for chrom in chroms:
        mids.append(get_mid(chromdata[chromdata["Scaffold_number"].eq(chrom)]))
    outframe["mid"] = mids
    return(outframe)
    #gapminder_2002 = gapminder[gapminder.year.eq(2002)]

def get_data(data_type, data_bed, chrlen_bed, offset):
    data = pd.read_csv(data_bed, sep="\t", header=None)
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

def combine_data(datas):
    return(pd.concat(datas))

def plot_combo(combo, outname, mids):
    ggdat = {"data": combo, "outname": outname, "mids": mids}
    
    command = """
    library(plyr)
    outname = jdata$outname
    mids = jdata$mids
    # labs = c("Gene", "Repeat_content")
    # names(labs) = c("Genes", "Repeats")
    scale = 2
    print(str(data$Feature))
    print(levels(factor(data$Feature)))
    temp = factor(data$Feature)
    print(str(temp))
    print(levels(factor(temp)))
    temp = revalue(temp, c("Low_complexity" = "Low\ncomp-\nlexity", "Simple_repeat" = "Simple\nrepeat"))
    print(str(temp))
    print(levels(factor(temp)))
    data$Feature = as.character(temp)
    print(str(data$Feature))
    print(levels(factor(data$Feature)))
    lf_feature = levels(factor(data$Feature))
    dummy = data.frame(Feature=lf_feature, true_density = 0, plotpos = min(data$plotpos))
    pdf(outname, height=3*4.6*scale, width=20*scale)
        aplot = ggplot(data = data, aes(plotpos, true_density)) +
            geom_point() +
            xlab("Chromosome") + 
            ylab("Feature bases per genome base") + ## y label from qqman::qq
            #scale_color_manual(values = c(gray(0.5), gray(0))) + ## instead of colors, go for gray
            #ggtitle("Chromosome-wide feature density") +
            theme_bw() +
            scale_y_continuous(labels = function(x) sprintf("%.2e", x)) +
            #scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) +
            #scale_y_continuous(breaks=seq(from=min(data$true_density), to=max(data$true_density), length.out=3)) +
            facet_grid(Feature~., scales="free_y") +
            scale_x_continuous(breaks = mids$mid, labels = mids$Scaffold_number) + ## add new x labels 
            geom_blank(data=dummy) +
            theme(text = element_text(size=48), panel.spacing = unit(1.8, "lines"), plot.margin = unit(c(.5,.5,.5,.5), "cm"))
        print(aplot)
    dev.off()
    
    #   facet_grid(Feature~., scales="free_y", labeller=labeller(Feature=labs)) +
    #   facet_wrap(.~NAME, ncol = 2) +
    #   guides(colour=FALSE) +  ## remove legend
    """
    pygg.ggplot(ggdat, command)

def main():
    offset = 5000000
    genedata = get_data("Genes", "answer_dens.bed", "reflens.txt", offset)
    with open("repeat_supergenus_counts_semiselect.txt", "r") as inconn:
        families = [x.rstrip('\n').split('\t')[-1] for x in inconn]
        repdata = get_data("Repeats", "repanswer_dens.bed", "reflens.txt", offset)
    datas = []
    for family in families:
        datas.append(get_data(family, "family_densities/repanswer_family_" + family + "_dens.bed", "reflens.txt", offset))
    datas.insert(0, repdata)
    datas.insert(0, genedata)
    combo = combine_data(datas)
    chrom_mids = get_chrom_mids(combo[["Scaffold", "Start", "End", "Scaffold_number", "plotpos"]], offset)
    print(combo.head())
    plot_combo(combo, "select_families_dens_pretty_3e.pdf", chrom_mids)

if __name__ == "__main__":
    main()
