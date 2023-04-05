package main

import (
	"fmt"
	"github.com/montanaflynn/stats"
	"encoding/csv"
	"io"
	"os"
	"strconv"
	"errors"
	"flag"
)

type col_indices struct {
	Sample int
	Intensity int
	ChromGC int
}

type Datas struct {
	Intensity stats.Float64Data
	ChromGC stats.Float64Data
}

type flag_set struct {
	Sample string
	Intensity string
	ChromGC string
}

func get_flags() (f flag_set) {
	flag.StringVar(&f.Sample, "s", "sample", "Name of column containing sample names.")
	flag.StringVar(&f.Intensity, "i", "afrac", "Name of column containing intensities to correlate.")
	flag.StringVar(&f.ChromGC, "g", "gc", "Name of column containing per-chromosome GC proportion.")
	flag.Parse()
	return f
}

func get_cols(header []string, f flag_set) (cols col_indices, err error) {
	var sample_ok, intensity_ok, gc_ok bool
	for i, v := range header {
		if v == f.Sample {
			cols.Sample = i
			sample_ok = true
		}
		if v == f.Intensity {
			cols.Intensity = i
			intensity_ok = true
		}
		if v == f.ChromGC {
			cols.ChromGC = i
			gc_ok = true
		}
	}
	if (!sample_ok) || (!intensity_ok) || (!gc_ok) {
		err = errors.New("Error: missing named columns.")
	}
	return cols, err
}

func NewCsv(r io.Reader) *csv.Reader {
	cr := csv.NewReader(r)
	cr.LazyQuotes = true
	cr.FieldsPerRecord = -1
	cr.Comma = rune('\t')
	cr.ReuseRecord = true
	return cr
}

func GetData(r io.Reader, f flag_set) (map[string]*Datas, error) {
	out := make(map[string]*Datas)
	var err error = nil

	cr := NewCsv(r)

	line, err := cr.Read()
	if err != nil { return nil, err }

	header := make([]string, len(line))
	copy(header, line)
	cols, err := get_cols(header, f)

	for line, err = cr.Read(); err != io.EOF; line, err = cr.Read() {
		if err != nil { return nil, fmt.Errorf("GetData inside line reading loop: %w", err) }

		sample_name := line[cols.Sample]
		f1, err := strconv.ParseFloat(line[cols.Intensity], 64)
		if err != nil { continue }
		f2, err := strconv.ParseFloat(line[cols.ChromGC], 64)
		if err != nil { continue }

		if _, ok := out[sample_name] ; !ok {
			out[sample_name] = new(Datas)
		}
		out[sample_name].Intensity = append(out[sample_name].Intensity, f1)
		out[sample_name].ChromGC = append(out[sample_name].ChromGC, f2)
	}
	return out, nil
}

func corr_all(data map[string]*Datas) (map[string]float64, error) {
	out := make(map[string]float64)
	var err error
	for sample, datum := range data {
		corr, err := stats.Correlation(datum.Intensity, datum.ChromGC)
		if err != nil { return out, err }
		out[sample] = corr
	}
	return out, err
}

func print_corrs(corrs map[string]float64) {
	fmt.Printf("sample\tgc_bias_weight\n")
	for sample, corr := range corrs {
		fmt.Printf("%s\t%v\n", sample, corr)
	}
}

func main() {
	flags := get_flags()
	data, err := GetData(os.Stdin, flags)
	if err != nil { panic(err) }
	corrs, err := corr_all(data)
	if err != nil { panic(err) }
	print_corrs(corrs)
}
