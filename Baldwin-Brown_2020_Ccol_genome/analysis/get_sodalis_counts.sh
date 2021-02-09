cat bads.gff | awk '$3=="gene"' | grep -i 'sodalis' | grep '^\S*old_4_' | wc -l
cat bads.gff | awk '$3=="gene"' | grep -i 'sodalis' | grep '^\S*old_8_' | wc -l
cat bads.gff | awk '$3=="gene"' | grep '^\S*old_4_' | wc -l
cat bads.gff | awk '$3=="gene"' | grep '^\S*old_8_' | wc -l
