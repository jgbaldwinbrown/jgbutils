###!/bin/bash

import fileinput
import os

cell_list_path="/bio/jbaldwi1/all_data_from_dfs2/peromyscus_data/work/quiver/cell_list.txt"
#iroot="/bio/jbaldwi1/dbg2olc/mel/quiver/cell_lists/fofns/"
oroot="quiver_outfiles/align_qsubs/"
assembly_type="ASSEMBLY_TYPE"
cells="CELLS"

with open(cell_list_path,"r") as cell_list_file:
  for linea in cell_list_file:
    line=linea.rstrip('\n')
    spaceline = " ".join(line.split())
    #linebase = line.split(".")[0]
    cell = line.split()[0]
    #ipath = iroot + line
    opath = oroot + "qsub_" + cell
    ofile=open(opath,"w")
    ofile.write("#!/bin/bash\n#$ -N quiver_align_1\n#$ -q bio,som,pub64,free64,free48,abio\n#$ -pe openmp 32-64\n#$ -ckpt restart\nmodule load enthought_python\nmodule load smrtanalysis/2.2.0p3\nmodule load boost\n\n")
    
    #mypwd=os.getcwd()
    #os.chdir("../..")
    ofile.write("echo " + spaceline + " | bash ../../get_bax_files.sh\n\n")
    #os.chdir(mypwd)
    
    ofile.write("pbalign.py --nproc $CORES --forQuiver --tmpDir /fast-scratch/jbaldwi1/ ")
    ofile.write("baxdata/" +cell + "/" + cell + "_fofn.fofn")
    ofile.write(" ../../ref/ref.fasta ../align_out/")
    ofile.write(cell + ".cmp.h5\n\n")
    
    #os.chdir("../..")
    ofile.write("echo " + spaceline + " | bash ../../remove_bax_files.sh\n")
    #os.chdir(mypwd)

#fout<<"pbalign.py --nproc 64 --forQuiver --tmpDir /fast-scratch/ /pub/jbaldwi1/shrimp_assembly/data/pacbio_data/pacbio_data/all_bax_h5/all_fofns/baxpaths_"<<str<< " /pub/jbaldwi1/shrimp_assembly/unmerged_assemblies/final_assembly.fasta /pub/jbaldwi1/shrimp_assembly/unmerged_assemblies/quivered/hybrid/align_out/";

#!/bin/bash
#$ -N qsub_0
#$ -q jje,bio,free64,abio,pub64
#$ -pe openmp 64
#module load enthought_python
#module load smrtanalysis
#module load boost
#pbalign.py --nproc 64 --forQuiver --tmpDir /fast-scratch/ /share/jje/mchakrab/pacbio/dmau/bax/31501.fofn /share/jje/mchakrab/pacbio/dmau/bax/p_ctg.fa /share/jje/mchakrab/pacbio/dmau/bax/31501.cmp.h5
