
export PATH=/home/jbaldwin/peromyscus/merge_test/mummer_64bit/MUMmer3.23:$PATH


mummer -l 100 self_oneline.fa final_assembly.fasta 1> nuc_out1.txt 2> nuc_out2.txt

#nucmer -l 100 -prefix merge_nuc_test_dbg2olc_first ${home}/dbg2olc_assembly/final_assembly.fasta self_oneline.fa 1> nuc_out1.txt 2> nuc_out2.txt



#python merge_wrapper.py ${home}/dbg2olc_assembly/final_assembly.fasta ${home}/pbcr_assembly/asm.scf.fasta -l 100000 1> merge_out.txt 2> merge_err.txt

