#!/usr/bin/env python3

import random
import tqdm

def sim(treatment, nsnps, npeaks, gensize, width, replicates, min_hits_needed):
    for replicate in tqdm.tqdm(range(replicates), desc="treatment"):
        snps=[random.randrange(gensize) for x in range(nsnps)]
        peaks=[]
        for npeak in range(npeaks):
            start = random.randrange(gensize-width)
            end = start + width
            done = False
            if len(peaks) > 0:
                while not done:
                    done = True
                    for oldpeak in peaks:
                        if not (start > oldpeak[1] or end < oldpeak[0]):
                            done=False
                            start = random.randrange(gensize-width)
                            end = start + width
            else:
                done=True
            peaks.append((start, end))
        hits = 0
        for p in peaks:
            per_peak_hits = 0
            for s in snps:
                if s >= p[0] and s<p[1]:
                    per_peak_hits += 1
            if per_peak_hits >= min_hits_needed:
                hits += 1
        print(treatment, replicates, nsnps, npeaks, hits, (hits/npeaks), sep="\t")

def main():
    maxsnps = 1400000
    nsnps_list = [int(maxsnps / x) for x in [1, 1.25, 1.5, 1.75, 2, 3, 4, 6, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]]
    nhits_needed_list = [1, 2, 4, 8, 16, 32, 64, 128]
    npeaks = 24
    width = 7708
    replicates = 30
    gensize = 150000000
    #for replicate in tqdm.tqdm(range(replicates), desc="replicates"):
    for nsnps in tqdm.tqdm(nsnps_list, desc="nsnps"):
        for nhits in tqdm.tqdm(nhits_needed_list, desc="nhits="):
            treatment = str(nsnps) + "_" + str(nhits)
            sim(treatment, nsnps, npeaks, gensize, width, replicates, nhits)

if __name__ == "__main__":
    main()
