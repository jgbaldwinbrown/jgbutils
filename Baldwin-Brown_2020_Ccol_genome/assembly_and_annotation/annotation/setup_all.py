#!/usr/bin/env python3

import os  
import shutil  
import pathlib
import subprocess

def main():
    tiled_ref_dir = "splits_reordered/"
    outdir = "outs/"
    tiled_ref_files = os.listdir(tiled_ref_dir)
    pwd = os.getcwd()
    for afile in tiled_ref_files:
        os.chdir(pwd)
        afile_path = tiled_ref_dir + "/" + afile
        full_outdir = outdir + afile + "_dir/"
        pathlib.Path(outdir).mkdir(parents=True, exist_ok=True)
        destination = shutil.copytree("template", full_outdir)
        gzoutdir = full_outdir + "/infiles/ref/ref/"
        gzout = gzoutdir + "/louseref.fasta.gz"
        shutil.copyfile(afile_path, gzout)
        subprocess.run(["gunzip", gzout])
        os.chdir(gzoutdir)
        subprocess.run(["./indexfa.sh", "louseref.fasta"])

if __name__ == "__main__":
    main()
   
## Source path  
#src = 'C:/Users / Rajnish / Desktop / GeeksforGeeks / source'
#   
## Destination path  
#dest = 'C:/Users / Rajnish / Desktop / GeeksforGeeks / destination'
#   
## Copy the content of  
## source to destination  
#destination = shutil.copytree(src, dest)  

#from pathlib import Path
#Path("/my/directory").mkdir(parents=True, exist_ok=True)
