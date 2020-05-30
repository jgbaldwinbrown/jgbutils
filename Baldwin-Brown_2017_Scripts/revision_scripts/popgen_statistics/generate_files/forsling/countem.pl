use List::Util qw[min max];
my %HoH = ();
foreach my $line (<STDIN>){
	chomp $line;
	my ($a,$b)  = split("\t",$line);
	my $T = $a+$b;
	my $C = min($a,$b);
	# print "$a\t$b\t$C\t$T\n";
	if (exists $HoH{$T}{$C}){
		$HoH{$T}{$C} = $HoH{$T}{$C} + 1;
		}else{
		$HoH{$T}{$C} = 1;
		}
	}

# n, i, Nsites, phi
# n = coverage, i = minor allele count, Nsites is the number of SNPs having this {n,i}, phi is the Fu formula 
#   = equation 1 is the Long paper https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1893025/
print "n\ti\tNsites\tphi\n";
for my $T ( keys %HoH ){
	for my $C ( keys %{ $HoH{$T} } ) {
		if($C/$T>0.1 & $T>25){					# maf > 10% and coverage greater than 25
			my $N = $HoH{$T}{$C};
			my $KD = 0;
			if($C == ($T-$C)){$KD=1;}
			my $phi = (1/(1+$KD)) * ((1/$C)+(1/($T-$C)));
			print "$T\t$C\t$N\t$phi\n";
			}
		}
	}

