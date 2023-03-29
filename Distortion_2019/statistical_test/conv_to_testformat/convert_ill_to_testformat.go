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
	fmt.Println("pos\tindiv\thits\talthits\tcount\ttissue\tchrom\tgc\tsample")
	pcols := []int {colmap["pos"], colmap["indiv"], colmap["hits"], colmap["althits"], colmap["count"], colmap["tissue"], colmap["chrom"], colmap["gc"], colmap["sample"]}

	W := fasttsv.NewWriter(w)
	defer W.Flush()

	s := fasttsv.NewScanner(r)
	outline := make([]string, 0, 100)

	s.Scan()
	for s.Scan() {
		outline = outline[:0]
		for _, i := range pcols {
			outline = append(outline, s.Line()[i])
		}
		W.Write(outline)
	}
}

func main() {
	chrom_gc_info, err := get_gc(os.Args[1])
	if err != nil { panic(err) }
	// colname_map := map[string]int{"pos": 2, "sample_index": 12, "value": 5, "tissue": 10, "chrom": 1, "sample": 14, "indiv": 11}
	colname_map := map[string]int{"pos": 1, "sample_index": 6, "hits": 8, "althits": 9, "count": 10, "tissue": 5, "chrom": 0, "sample": 6, "indiv": 6, "gc": 2}
	print_new_format(os.Stdin, os.Stdout, chrom_gc_info, colname_map)
}

/*
==> alldata_head.txt.gz <==
chrom	pos	gc	ref	alt	tissue	sample	gt	hits	althits	count
NC_000001.11	13273	0.43	G	C	Sperm	15458X10	0/0	3	0	3
NC_000001.11	13417	0.43	C	CGAGA	Sperm	15458X10	0/0	1	0	1
==> reannotated_melted_all_afrac.txt.gz <==
probeset_id	Chromosome	Position	Offset	Big_Offset	afrac	let	num	experiment	sex	tissue	indivs	unique_id	plate_id	name_prefix	spoofed_tissue
AX-11414494	MT	15607	NA	NA	NA	A	07	wild_sample	male	sperm	291	00332	1	Utah_Plate01_A07	sperm
AX-11414507	MT	14905	NA	NA	NA	A	07	wild_sample	male	sperm	291	00332	1	Utah_Plate01_A07	sperm
==> reannotated_melted_micro_afrac_reformat.txt.gz <==
pos	indiv	value	tissue	chrom	gc	sample
86028	301	NA	blood	1	0.43	00301
720240	301	NA	blood	1	0.43	00301
==> reannotated_melted_micro_afrac.txt.gz <==
probeset_id	Chromosome	Position	Offset	Big_Offset	afrac	let	num	experiment	sex	tissue	indivs	unique_id	plate_id	name_prefix	spoofed_tissue
AX-13216142	1	86028	86028	86028	NA	C	06	wild_sample	male	blood	301	00301	1	Utah_Plate01_C06	blood
AX-32104085	1	720240	720240	720240	NA	C	06	wild_sample	male	blood	301	00301	1	Utah_Plate01_C06	blood
==> reannotated_melted_totals.txt.gz <==
probeset_id	Chromosome	Position	Offset	Big_Offset	total_intensity	let	num	experiment	sex	tissue	indivs	unique_id	plate_id	name_prefix	spoofed_tissue
AX-11414494	MT	15607	NA	NA	3598.65631	A	04	wild_sample	male	blood	289	00289	1	Utah_Plate01_A04	blood
AX-11414507	MT	14905	NA	NA	5694.79419	A	04	wild_sample	male	blood	289	00289	1	Utah_Plate01_A04	blood
==> reannoted_melted_micro_afrac_reformat_gc_bloodstats.txt.gz <==
pos	indiv	value	tissue	chrom	gc	sample	sample_gc_corr	per_chrom_gc_index	bloodmean	bloodsd
86028	301	NA	blood	1	0.43	00301	-3.0436595941067905e-15	-1.3087736254659199e-15	0.6224896177608821	0.06849095500608116
720240	301	NA	blood	1	0.43	00301	-3.0436595941067905e-15	-1.3087736254659199e-15	NA	NA
==> reannoted_melted_micro_afrac_reformat_gc.txt.gz <==
pos	indiv	value	tissue	chrom	gc	sample	sample_gc_corr	per_chrom_gc_index
86028	301	NA	blood	1	0.43	00301	-3.0436595941067905e-15	-1.3087736254659199e-15
720240	301	NA	blood	1	0.43	00301	-3.0436595941067905e-15	-1.3087736254659199e-15

*/
