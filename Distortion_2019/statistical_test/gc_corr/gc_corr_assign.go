package main

import (
	"log"
	"fmt"
	"encoding/csv"
	"io"
	"os"
	"errors"
	"flag"
	"strconv"
)

type col_indices struct {
	Sample int
	Gc int
}

type flag_set struct {
	Sample string
	GcCol string
	GcPath string
}

type GcData struct {
	AsStr string
	AsFlo float64
	Na bool
}

func get_flags() (f flag_set) {
	flag.StringVar(&f.Sample, "s", "", "Name of column containing sample names.")
	flag.StringVar(&f.GcCol, "g", "", "Name of column containing per-chromosome GC fraction.")
	flag.StringVar(&f.GcPath, "G", "", "Path to column-separated file containing correlation with GC for each sample.")
	flag.Parse()

	if f.GcPath == "" {
		log.Fatal("missing -G")
	}
	if f.GcCol == "" {
		log.Fatal("missing -g")
	}
	if f.Sample == "" {
		log.Fatal("missing -s")
	}
	return f
}

func get_cols(header []string, f flag_set) (cols col_indices, err error) {
	var sample_ok, gc_ok bool
	for i, v := range header {
		if v == f.Sample {
			cols.Sample = i
			sample_ok = true
		}
		if v == f.GcCol {
			cols.Gc = i
			gc_ok = true
		}
	}
	if (!sample_ok) || (!gc_ok) {
		err = errors.New("Error: missing named columns.")
	}
	return cols, err
}

func NewCsv(r io.Reader) *csv.Reader {
	cr := csv.NewReader(r)
	cr.ReuseRecord = true
	cr.LazyQuotes = true
	cr.FieldsPerRecord = -1
	cr.Comma = rune('\t')
	return cr
}

func GetGcData(r io.Reader) (map[string]GcData, error) {
	out := make(map[string]GcData)
	var err error = nil
	cr := NewCsv(r)
	line, err := cr.Read()
	if err != nil {
		return nil, fmt.Errorf("GetGcData: header: %w", err)
	}

	for line, err = cr.Read(); err != io.EOF; line, err = cr.Read() {
		if err != nil {
			return nil, fmt.Errorf("GetGcData: line loop: %w", err)
		}
		var gc_data GcData
		gc_data.AsStr = line[1]
		gc_data.AsFlo, err = strconv.ParseFloat(line[1], 64)
		if err != nil {
			gc_data.Na = true
		}
		out[line[0]] = gc_data
	}
	return out, nil
}

func assoc_and_print_all(r io.Reader, w io.Writer, gc_data map[string]GcData, f flag_set) error {
	var err error = nil
	cr := NewCsv(r)

	line, err := cr.Read()
	if err != nil { return err }

	header := make([]string, len(line))
	copy(header, line)
	cols, err := get_cols(header, f)
	if err != nil { return err }
	header = append(header, "sample_gc_corr", "per_chrom_gc_index")

	W := csv.NewWriter(w)
	W.Comma = rune('\t')
	defer W.Flush()
	W.Write(header)

	outline := make([]string, 0, 0)

	for line, err := cr.Read(); err != io.EOF; line, err = cr.Read() {
		if err != nil { return err }

		gc_corr, ok := gc_data[line[cols.Sample]]
		if !ok {
			gc_corr.AsStr = "NA"
			gc_corr.Na = true
		}

		outline = outline[:0]
		outline = append(outline, line...)
		outline = append(outline, gc_corr.AsStr)

		chrom_gc_frac, err := strconv.ParseFloat(line[cols.Gc], 64)
		if (err != nil) || gc_corr.Na {
			outline = append(outline, "NA")
		} else {
			per_chrom_gc_index := chrom_gc_frac * gc_corr.AsFlo
			outline = append(outline, fmt.Sprintf("%v", per_chrom_gc_index))
		}
		W.Write(outline)
	}

	return nil
}

func main() {
	flags := get_flags()

	gc_conn, err := os.Open(flags.GcPath)
	if err != nil {panic(err) }
	defer gc_conn.Close()

	gc_values, err := GetGcData(gc_conn)
	if err != nil { panic(err) }

	assoc_and_print_all(os.Stdin, os.Stdout, gc_values, flags)
}
