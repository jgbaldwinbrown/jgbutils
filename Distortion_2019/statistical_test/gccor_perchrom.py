#!/usr/bin/env python3

import statsmodels.api as sm
from statsmodels.formula.api import ols
import copy
import argparse
import sys
import numpy as np
import pandas as pd

def parse_all_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("file", nargs="?", help="File to filter (default=stdin).")
    parser.add_argument("-c", "--chrom_col", help="Column containing chromosome names.", required=True)
    parser.add_argument("-g", "--gc_col", help="Column containing gc content.", required=True)
    parser.add_argument("-s", "--sample_col", help="Column containing sample names.", required=True)
    parser.add_argument("-v", "--value_col", help="Column containing values to modify.", required=True)
    parser.add_argument("-H", "--header", help="specify if input has a header line.", action="store_true")

    args = parser.parse_args()
    out = {}
    if args.file:
        out["inconn"] = open(args.file, "r")
    else:
        out["inconn"] = sys.stdin
    out["chrom_col"] = int(args.chrom_col)
    out["gc_col"] = int(args.gc_col)
    out["sample_col"] = int(args.sample_col)
    out["value_col"] = int(args.value_col)
    if args.header:
        out["header"] = True
    else:
        out["header"] = False
    return(out)

def read_data(args):
    if args["header"]:
        data = pd.read_csv(args["inconn"], sep="\t", header=0)
    else:
        data = pd.read_csv(args["inconn"], sep="\t", header=None)
    cols = [x for x in data.columns]
    cols[args["chrom_col"]] = "chrom"
    cols[args["gc_col"]] = "gc"
    cols[args["sample_col"]] = "sample"
    cols[args["value_col"]] = "value"
    data.columns = cols
    return(data)

def calc_gcfrac(gcpercs, values):
    total_value = sum(values)
    gc_portions = gcpercs * values
    gc_total_value = sum(gc_portions)
    gcfrac = gc_total_value / total_value
    return(gcfrac)

def get_all_gcfracs(data, samples):
    sample_gcfracs = {}
    for sample in samples:
        sample_data = data[data["sample"]==sample]
        sample_gcfracs[sample] = calc_gcfrac(sample_data["gc"].to_numpy(), sample_data["value"].to_numpy())
    return(sample_gcfracs)

def get_sample_gcfracs_list(sample_gcfracs, samples):
    return(samples.apply(lambda x: sample_gcfracs[x]))

def add_gcfrac(data, args):
    samples = set(data["sample"].tolist())
    sample_gcfracs = get_all_gcfracs(data, samples)
    newdata = copy.deepcopy(data)
    newdata["gcfracs"] = get_sample_gcfracs_list(sample_gcfracs, data["sample"])
    return(newdata)

def get_chrom_gc_models(data, chroms):
    chrom_gc_models = {}
    for chrom in chroms:
        chrom_data = data[data["chrom"]==chrom]
        chrom_model = ols('value ~ gcfracs', data=chrom_data).fit()
        chrom_gc_models[chrom] = chrom_model
    return(chrom_gc_models)

def get_gcfrac_expected_value(chrom_gc_model, gcfracs):
    return(chrom_gc_model.predict(pd.DataFrame({"gcfracs": gcfracs}, index=[0])))

def get_gcfrac_expected_values(chrom_gc_models, data):
    minidata = data[["chrom", "gcfracs"]]
    return(data.apply( lambda x: get_gcfrac_expected_value( chrom_gc_models[x.loc["chrom"]], x.loc["gcfracs"]), axis = 1))

def add_gcfrac_expected_values(data, args):
    lms = {}
    chroms = set(data["chrom"].tolist())
    chrom_gc_models = get_chrom_gc_models(data, chroms)
    out_data = copy.deepcopy(data)
    out_data["gcfrac_expected_value"] = get_gcfrac_expected_values(chrom_gc_models, data)
    return(out_data)

def add_adjusted_values(data, args):
    out_data = copy.deepcopy(data)
    out_data["adjusted_value"] = out_data["value"] - out_data["gcfrac_expected_value"]
    return(out_data)

def main():
    args = parse_all_args()
    
    data = read_data(args)
    args["inconn"].close()

    data_with_gcfrac = add_gcfrac(data, args)
    data_with_gcfrac_and_expected = add_gcfrac_expected_values(data_with_gcfrac, args)
    final_data = add_adjusted_values(data_with_gcfrac_and_expected, args)
    
    final_data.to_csv(sys.stdout,sep="\t", header=True, index=False)

if __name__ == "__main__":
    main()
