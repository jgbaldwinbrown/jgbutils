cat ../../blast_for_grant_blurb/alan_rna_to_aug_prot_v1/alan_rna_to_aug_prot_v1.out | cut -d '     ' -f 1,2 | cut -d '.' -f 1,2 | awk '{print $2 "\t" $1}' > pairfile_rna_to_aug_prot_switched.txt
