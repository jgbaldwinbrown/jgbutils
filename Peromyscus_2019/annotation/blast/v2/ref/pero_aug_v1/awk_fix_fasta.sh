awk -v RS=">" -v FS="\n" -v ORS="" ' { if ($2) print ">"$0 } ' your_fasta_file.fna > output.fna
