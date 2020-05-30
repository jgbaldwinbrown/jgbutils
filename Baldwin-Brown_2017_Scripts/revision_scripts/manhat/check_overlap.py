#!/usr/bin/env python3

def to_coords(datum):
    return((int(datum[1]), int(datum[2])))

def makeset(data):
    out = {}
    for datum in data["data"]:
        out[to_coords(datum)] = datum
    return(out)
    #fstset = set([[int(y) for y in x[1:3]] for x in fstdat])

def writedat(data, path):
    with open(path, "w") as oconn:
        oconn.write("\t".join(data["header"]) + "\n")
        for sl in data["data"]:
            oconn.write("\t".join(sl) + "\n")

def overlap(data, cutoff, ovlset):
    out = {}
    out["header"] = data["header"]
    out["data"] = []
    for datum in data["data"]:
        coor = to_coords(datum)
        value = float(datum[3])
        if value >= cutoff and coor in ovlset:
            datum.extend(ovlset[coor])
            out["data"].append(datum)
    return(out)

def readpath(path):
    bigout = {}
    bigout["data"] = []
    for i, l in enumerate(open(path, "r")):
        sl = l.rstrip('\t').split()
        if i == 0:
            bigout["header"] = sl
        else:
            bigout["data"].append(sl)
    return(bigout)

def main():
    fstpath = "manhatify_test/testout_manhat_format.txt"
    xtxpath = "/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/subsets/manhatify_test/xtxsorted.txt"
    bextxpath = "./bayenv_xtx/out_manhat_format.txt"
    fstdat = readpath(fstpath)
    xtxdat = readpath(xtxpath)
    bextxdat = readpath(bextxpath)
    fstset = makeset(fstdat)
    xtxset = makeset(xtxdat)
    bextxset = makeset(bextxdat)
    #print(fstdat["header"])
    #print(fstdat["data"][:3])
    #print(xtxdat["header"])
    #print(xtxdat["data"][:3])
    #print(bextxdat["header"])
    #print(bextxdat["data"][:3])
    xtxcutoff = 30.0
    bextxcutoff = 40.0
    new_opath = "new_hits_in_old.txt"
    old_opath = "old_hits_in_new.txt"
    news_in_old = overlap(xtxdat, xtxcutoff, bextxset)
    olds_in_new = overlap(bextxdat, bextxcutoff, xtxset)
    writedat(news_in_old, new_opath)
    writedat(olds_in_new, old_opath)

if __name__ == "__main__":
    main()
