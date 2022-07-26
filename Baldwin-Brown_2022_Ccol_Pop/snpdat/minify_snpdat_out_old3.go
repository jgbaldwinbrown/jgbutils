package main

import (
	"strconv"
	"bufio"
	"github.com/jgbaldwinbrown/fasttsv"
	"compress/gzip"
	"os"
)

func main() {
	in1, err := os.Open("snpdat_out.txt.gz")
	if err != nil { panic(err) }
	defer in1.Close()
	in, err := gzip.NewReader(in1)
	if err != nil { panic(err) }
	defer in.Close()
	s := fasttsv.NewScanner(in)

	out1, err := os.Create("snpdat_out_small.txt.gz")
	if err != nil { panic(err) }
	defer out1.Close()
	outg := gzip.NewWriter(out1)
	defer outg.Close()
	out := bufio.NewWriter(outg)
	defer out.Flush()

	out2, err := os.Create("snpdat_out_tiny.txt.gz")
	if err != nil { panic(err) }
	defer out2.Close()
	outg2 := gzip.NewWriter(out2)
	defer outg2.Close()
	out2_2 := bufio.NewWriter(outg2)
	defer out2_2.Flush()

	out3, err := os.Create("snpdat_out_forplot.txt.gz")
	if err != nil { panic(err) }
	defer out3.Close()
	outg3 := gzip.NewWriter(out3)
	defer outg3.Close()
	out3_3 := bufio.NewWriter(outg3)
	defer out3_3.Flush()

	buf := []byte{}
	outl := []string{}
	for s.Scan() {
		l := s.Line()
		if l[2] != "NA" {
			outl = append(outl[:0], l[0], l[1], l[2], l[3], l[5], l[18], l[21])
			fasttsv.FprintlnEscape(out, &buf, outl, '\t', '\\')

			outl = append(outl[:0], l[0], l[1], l[2], l[21])
			fasttsv.FprintlnEscape(out2_2, &buf, outl, '\t', '\\')

			pos, err := strconv.ParseInt(l[1], 0, 64)
			start := "NA"
			end := "NA"
			if err == nil {
				start = strconv.FormatInt(pos-1, 10)
				end = strconv.FormatInt(pos, 10)
			}
			snptype := "synonymous"
			if l[21] == "N" {
				snptype = "nonsynonymous"
			}
			outl = append(outl[:0], l[0], start, end, snptype)
			fasttsv.FprintlnEscape(out3_3, &buf, outl, '\t', '\\')
		}
	}
}

//CHR1	3542262	Y	Exonic	NA	exon	3	[1/1]	3542028	3542401	chr1-aug-35.15-mRNA-1	NA	chr1-aug-35.15	NA	[NA/]	-	NA	-2	0	C[A/T]T	[H/L]	N	NA	

// Chromosome Number       SNP Position    Within a Feature        Region  Distance to nearest feature     Feature Number of different features for this SNP
//        Number of annotations for this feature  Start of current feature        End of current feature  gene ID containing the current feature  gene name containing the current feature        transcript ID containing the current feature    transcript name containing the current feature  Annotated Exon [Rank/Total]
//      Strand sense    Annotated reading Frame Estimated Reading Frame Estimated Number of Stop Codons Codon   Amino Acid      synonymous      Protein ID containing the current feature       Additional Notes
