package main

import (
	"flag"
	"io"
	"fmt"
	"encoding/csv"
	"os"
)

func get_gc(inpath string) (out map[string]string, err error) {
	out = make(map[string]string)
	r, err := os.Open(inpath)
	if err != nil { return out, err }
	defer r.Close()

	cr := csv.NewReader(r)
	cr.Comma = rune('\t')
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true
	cr.LazyQuotes = true

	for l, e := cr.Read(); e != io.EOF; l, e = cr.Read() {
		out[l[0]] = l[1]
	}

	return out, err
}

func append_gc_col(r io.Reader, w io.Writer, chrom_gc_info map[string]string, chromcol int) error {
	h := func(e error) error {
		return fmt.Errorf("append_gc_col: %w", e)
	}

	cr := csv.NewReader(r)
	cr.Comma = rune('\t')
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true
	cr.LazyQuotes = true

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	l, e := cr.Read()
	if e != nil { return h(e) }
	e = cw.Write(append(l, "gc"))
	if e != nil { return h(e) }

	for l, e = cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { return h(e) }

		l = append(l, chrom_gc_info[l[chromcol]])
		e = cw.Write(l)
		if e != nil { return h(e) }
	}

	return nil
}

func main() {
	chrom_gc_info_pathp := flag.String("gc", "", "path to chromosome gc values")
	chromcolp := flag.Int("c", -1, "column containing chromosomes to give gc values")
	flag.Parse()

	if *chrom_gc_info_pathp == "" {
		panic(fmt.Errorf("Missing -gc"))
	}

	if *chromcolp == -1 {
		panic(fmt.Errorf("Missing -c"))
	}

	chrom_gc_info, err := get_gc(*chrom_gc_info_pathp)
	if err != nil { panic(err) }

	append_gc_col(os.Stdin, os.Stdout, chrom_gc_info, *chromcolp)
}
