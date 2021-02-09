#!/usr/bin/env python3

import pandas as pd
import pygg
import json


data = pd.read_csv("aeds_prot.txt", sep="\t", header=0)
data = data.sort_values("aed")
datalen = data.shape[0]
data["frac"] = [float(x) / datalen for x in range(data.shape[0])]
print(data)
jdata = {"data": data}

ggc = """
a = ggplot(data=data, aes(aed, frac)) + geom_line() +
geom_vline(xintercept=.5, linetype="dashed") +
theme_bw() +
labs(y="Cumulative proportion of all transcripts", x="AED", title="Annotation AED scores")

pdf("aeds4_final.pdf", height=3, width=4)
print(a)
dev.off()
"""

pygg.ggplot(jdata, ggc)
