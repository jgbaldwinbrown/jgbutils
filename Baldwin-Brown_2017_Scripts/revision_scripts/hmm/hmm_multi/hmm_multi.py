#!/usr/bin/env python3

xtx_commands = []
xtx_dones = []
bextx_commands = []
bextx_dones = []
depscore = "../hmm.R outdir/outdir.done"
xtxpath = "../../full_run/inter/bpout_test/bpout_summary_pi_xtx.out"
bextxpath = "../../manhat/manhatify_test/xtxout_manhat_format.txt"
#/home/jgbaldwinbrown/Documents/work_stuff/clam_shrimp/shrimp_assembly/assembly_paper/paper/word_version/fst_version_52_gbe_revision/new_stuff/full_baypass/Baldwin-Brown_2017_Scripts/revision_scripts/manhat/manhatify_test/xtxout_manhat_format.txt

depsxtx = depscore + " " + xtxpath
depsbextx = depscore + " " + bextxpath
command_template = "Rscript ../hmm.R"
command_template_xtx = "Rscript ../hmm.R" + " " + xtxpath
command_template_bextx = "Rscript ../hmm.R" + " " + bextxpath

for m in [18, 20, 22]:
    for s in [9, 18]:
        ms = (float(m), float(s))
        for M in [100]:
            for S in [200]:
                MS = (float(M), float(S))
                out = "".join(map(str, ["outdir/hmm_xtx_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".txt"]))
                outopt = "-o " + out
                pout = "".join(map(str, ["outdir/hmm_xtx_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".png"]))
                poutopt = "-p " + pout
                dopt = "-d P"
                xtx_commands.append(" ".join(map(str, [
                    command_template_xtx,
                    outopt,
                    poutopt,
                    "-m",ms[0],
                    "-s", ms[1],
                    "-M", MS[0],
                    "-S", MS[1]
                ])))
                xtx_dones.append(out + ".done")
                
                out = "".join(map(str, ["outdir/hmm_bextx_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".txt"]))
                outopt = "-o " + out
                pout = "".join(map(str, ["outdir/hmm_bextx_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".png"]))
                poutopt = "-p " + pout
                bextx_commands.append(" ".join(map(str, [
                    command_template_bextx,
                    outopt,
                    poutopt,
                    dopt,
                    "-m",ms[0],
                    "-s", ms[1],
                    "-M", MS[0],
                    "-S", MS[1]
                ])))
                bextx_dones.append(out + ".done")


print("all: " + " ".join(xtx_dones) + " "  + " ".join(bextx_dones))
print("")
print("outdir/outdir.done:")
print("\tmkdir -p outdir")
print("\ttouch outdir/outdir.done")

for command, done in zip(xtx_commands, xtx_dones):
    print(done + ": " + depsxtx)
    print("\t" + command)
    print("\ttouch " + done)

for command, done in zip(bextx_commands, bextx_dones):
    print(done + ": " + depsbextx)
    print("\t" + command)
    print("\ttouch " + done)

#hmm_test.R
##!/bin/bash
#set -e
#
#Rscript ../hmm/hmm.R inter/bpout_test/bpout_summary_pi_xtx.out -o out/hmm_test_out.txt -p out/hmm_test_out.png -m 10.99 -s 3.10 -M 25 -S 20
