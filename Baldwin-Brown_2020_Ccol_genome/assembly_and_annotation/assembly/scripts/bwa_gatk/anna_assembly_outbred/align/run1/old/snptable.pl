use strict;
use warnings;
my $NumberOfStrains = shift(@ARGV);
chomp $NumberOfStrains;
my $AcceptableMissing = shift(@ARGV);
chomp $AcceptableMissing;
while (my $line = <STDIN>){
chomp $line;
if($line =~ /^#CHROM\t/){
	$line =~ s/#CHROM/CHROM/;
	my @blowline = split("\t",$line);
	print "Nmiss\t$blowline[0]\t$blowline[1]\t$blowline[3]\t$blowline[4]";
	for(my $i = 0; $i<$NumberOfStrains; $i++){
		my $temp = $blowline[9+$i];
		print "\tfreq_".$temp."\tN_".$temp;
		}
	print "\n";
	}
unless($line =~ /^##/ || $line =~ /^CHROM\t/){
	my $temp = "";
	my $missing = 0;
	my @ss = split("\t",$line);
	my @biallele = split(",",$ss[4]);
	#  ancestral versus derived both length 1
	if(scalar @biallele == 1){
		$temp = "$ss[0]\t$ss[1]\t$ss[3]\t$ss[4]";
		for(my $i=9; $i<(9+$NumberOfStrains); $i++){
			if($ss[$i] =~ /^[0-9\.]\/[0-9\.]$/){
				$temp = $temp."\tNA\t0";
				$missing++;
				}else{
				my @tt = split(":",$ss[$i]);
				my @qq = split(",",$tt[1]);
				my $A = $qq[0];
				my $B = $qq[1];
				my $TotalCount = $A + $B;
				if($TotalCount==0){
					$temp = $temp."\tNA\t0";
					$missing++;
					}else{
					my $RefFreq = $A/$TotalCount;
					$temp = $temp."\t".sprintf("%.2f",$RefFreq)."\t$TotalCount";
					}
				}
			} # over strains
		if($missing <= $AcceptableMissing){print "$missing\t$temp\n";}
		} # biallelic true SNP
	} # line of vcf file describing a SNP
}  # lines in vcf file
exit();
