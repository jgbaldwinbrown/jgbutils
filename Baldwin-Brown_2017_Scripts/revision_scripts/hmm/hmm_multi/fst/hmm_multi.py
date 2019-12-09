#!/usr/bin/env python3

fst_commands = []
fst_dones = []
befst_commands = []
befst_dones = []
depscore = "../hmm.R outdir/outdir.done"
fstpath = "../../../manhat/manhatify_test/testout_manhat_format_nonan.txt"
befstpath = "../../../manhat/old_correct_fst/out_manhat_format_nonan.txt"

depsfst = depscore + " " + fstpath
depsbefst = depscore + " " + befstpath
command_template = "Rscript ../hmm.R"
command_template_fst = "Rscript ../hmm.R" + " " + fstpath
command_template_befst = "Rscript ../hmm.R" + " " + befstpath

for m in [0.24]:
    for s in [0.12, 0.24, 0.36, 0,48]:
        ms = (float(m), float(s))
        for M in [0.8]:
            for S in [0.4, 0.8, 1.6]:
                MS = (float(M), float(S))
                out = "".join(map(str, ["outdir/hmm_fst_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".txt"]))
                outopt = "-o " + out
                pout = "".join(map(str, ["outdir/hmm_fst_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".png"]))
                poutopt = "-p " + pout
                dopt = "-d P"
                fst_commands.append(" ".join(map(str, [
                    command_template_fst,
                    outopt,
                    poutopt,
                    dopt,
                    "-m",ms[0],
                    "-s", ms[1],
                    "-M", MS[0],
                    "-S", MS[1]
                ])))
                fst_dones.append(out + ".done")
                
                out = "".join(map(str, ["outdir/hmm_befst_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".txt"]))
                outopt = "-o " + out
                pout = "".join(map(str, ["outdir/hmm_befst_", ms[0], "_s", ms[1], "_M", MS[0], "_S", MS[1], ".png"]))
                poutopt = "-p " + pout
                befst_commands.append(" ".join(map(str, [
                    command_template_befst,
                    outopt,
                    poutopt,
                    dopt,
                    "-m",ms[0],
                    "-s", ms[1],
                    "-M", MS[0],
                    "-S", MS[1]
                ])))
                befst_dones.append(out + ".done")


print("all: " + " ".join(fst_dones) + " "  + " ".join(befst_dones))
print("")
print("outdir/outdir.done:")
print("\tmkdir -p outdir")
print("\ttouch outdir/outdir.done")

for command, done in zip(fst_commands, fst_dones):
    print(done + ": " + depsfst)
    print("\t" + command)
    print("\ttouch " + done)

for command, done in zip(befst_commands, befst_dones):
    print(done + ": " + depsbefst)
    print("\t" + command)
    print("\ttouch " + done)
