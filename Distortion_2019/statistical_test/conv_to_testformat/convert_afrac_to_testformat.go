package main

import (
	"io"
	"fmt"
	"github.com/jgbaldwinbrown/fasttsv"
	"os"
)

func get_gc(inpath string) (out map[string]string, err error) {
	out = make(map[string]string)
	r, err := os.Open(inpath)
	if err != nil { return out, err }
	defer r.Close()

	s := fasttsv.NewScanner(r)
	for s.Scan() {
		out[s.Line()[0]] = s.Line()[1]
	}

	return out, err
}

func print_new_format(r io.Reader, w io.Writer, chrom_gc_info map[string]string, colmap map[string]int) {
	fmt.Println("pos\tindiv\tvalue\ttissue\tchrom\tgc\tsample")
	pcols := []int {colmap["pos"], colmap["indiv"], colmap["value"], colmap["tissue"], colmap["chrom"], colmap["sample"]}

	W := fasttsv.NewWriter(w)
	defer W.Flush()

	s := fasttsv.NewScanner(r)
	outline := make([]string, 0, 100)

	s.Scan()
	for s.Scan() {
		outline = outline[:0]
		for _, i := range pcols[:5] {
			outline = append(outline, s.Line()[i])
		}
		outline = append(outline, chrom_gc_info[s.Line()[pcols[4]]])
		outline = append(outline, s.Line()[pcols[5]])
		W.Write(outline)
	}
}

func main() {
	chrom_gc_info, err := get_gc(os.Args[1])
	if err != nil { panic(err) }
	// colname_map := map[string]int{"pos": 2, "sample_index": 12, "value": 5, "tissue": 10, "chrom": 1, "sample": 14, "indiv": 11}
	colname_map := map[string]int{"pos": 2, "sample_index": 12, "value": 5, "tissue": 15, "chrom": 1, "sample": 12, "indiv": 11}
	print_new_format(os.Stdin, os.Stdout, chrom_gc_info, colname_map)
}
