package main

import (
	// "strings"
	// "strconv"
	"bufio"
	"local/jgbaldwinbrown/fasttsv"
	"local/jgbaldwinbrown/fastgz"
	"os"
	"github.com/pkg/profile"
)

func main() {
	defer profile.Start().Stop()
	in1, err := os.Open("snpdat_out.txt.gz")
	if err != nil { panic(err) }
	defer in1.Close()
	in2 := bufio.NewReader(in1)
	in, err := fastgz.Gunzip(in2, 8)
	if err != nil { panic(err) }
	defer in.Close()
	s := fasttsv.NewScanner(in)

	out1, err := os.Create("snpdat_out_small.txt.gz")
	if err != nil { panic(err) }
	defer out1.Close()
	outg, err := fastgz.Gzip(out1, 8)
	if err != nil { panic(err) }
	defer outg.Close()
	out := bufio.NewWriter(outg)
	defer out.Flush()

	out2, err := os.Create("snpdat_out_tiny.txt.gz")
	if err != nil { panic(err) }
	defer out2.Close()
	outg2, err := fastgz.Gzip(out2, 8)
	if err != nil { panic(err) }
	defer outg2.Close()
	out2_2 := bufio.NewWriter(outg2)
	defer out2_2.Flush()

	out3, err := os.Create("snpdat_out_forplot2.txt.gz")
	if err != nil { panic(err) }
	defer out3.Close()
	outg3, err := fastgz.Gzip(out3, 8)
	if err != nil { panic(err) }
	defer outg3.Close()
	out3_3 := bufio.NewWriter(outg3)
	defer out3_3.Flush()

	buf := []byte{}
	outl := []string{}
	s.Scan()
	for s.Scan() {
		l := s.Line()
		if l[2] != "NA" {
			outl = append(outl[:0], l[0], l[1], l[2], l[3], l[5], l[18], l[21])
			fasttsv.FprintlnEscape(out, &buf, outl, '\t', '\\', "\t")

			// outl = append(outl[:0], l[0], l[1], l[2], l[21])
			// fasttsv.FprintlnEscape(out2_2, &buf, outl, '\t', '\\', "\t")

			// pos, err := strconv.ParseInt(l[1], 0, 64)
			// start := "NA"
			// end := "NA"
			// if err == nil {
			// 	start = strconv.FormatInt(pos-1, 10)
			// 	end = strconv.FormatInt(pos, 10)
			// }
			// snptype := "synonymous"
			// if l[21] == "N" {
			// 	snptype = "nonsynonymous"
			// }
			// outl = append(outl[:0], strings.ToLower(l[0]), start, end, snptype)
			// fasttsv.FprintlnEscape(out3_3, &buf, outl, '\t', '\\', "\t")
		}
	}
}
