#!/usr/bin/env python3

import os  
import shutil  
import pathlib
import subprocess

def main():
    outdir = "outs/"
    dirs_to_run = os.listdir(outdir)
    dirpaths_to_run = [outdir + dir_to_run for dir_to_run in dirs_to_run]
    paths_to_run = [dirpath + "/run_maker2.sh" for dirpath in dirpaths_to_run]
    pwd = os.getcwd()
    for dirpath in dirpaths_to_run:
        os.chdir(pwd)
        os.chdir(dirpath)
        subprocess.run(["sbatch", "run_maker2.sh"])

if __name__ == "__main__":
    main()
   

# outs/width_10000_v0.fa.gz_dir/run_maker2.sh


