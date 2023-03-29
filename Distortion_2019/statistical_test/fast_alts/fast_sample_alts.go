package main

import (
	"strconv"
	"io"
	"fmt"
	"github.com/montanaflynn/stats"
	"github.com/jgbaldwinbrown/fasttsv"
	"flag"
	"os"
	"compress/gzip"
)

type chrpos struct {
	chrom string
	pos int
}

type data_entry struct {
	chrpos
	freq float64
	sample string
	freq_bloodmean float64
	freq_bloodsd float64
	tissue string
}

type dataframe struct {
	entries []data_entry
}

type posentry struct {
	freqs []float64
	bloodmean float64
	bloodsd float64
}

type samplemap map[string]*posentry

func mapit(d dataframe) (cmap samplemap) {
	cmap = make(samplemap)
	for _, e := range d.entries {
		vals, ok := cmap[e.sample]
		if ! ok {
			cmap[e.sample] = new(posentry)
			vals = cmap[e.sample]
		}
		vals.freqs = append(vals.freqs, e.freq)
	}
	return
}

func parse_data(r io.Reader, use_hits bool, use_count bool) (data dataframe, err error) {
	s := fasttsv.NewScanner(r)
	s.Scan()

	header := make(map[string]int)
	for i, v := range s.Line() {
		header[v] = i
	}

	var hitscol, countcol int
	var ok bool
	if use_hits {
		hitscol, ok = header["hits"]
		if !ok { return data, fmt.Errorf("Error: column %s not found.", "hits") }
		countcol, ok = header["count"]
		if !ok { return data, fmt.Errorf("Error: column %s not found.", "count") }
	}

	freqcol, ok := header["value"]
	if !ok || use_count {
		freqcol, ok = header["count"]
		if !ok {
			return data, fmt.Errorf("Error: column %s not found.", "freq")
		}
	}
	poscol, ok := header["Position"]
	if !ok { return data, fmt.Errorf("Error: column %s not found.", "col") }
	chromcol, ok := header["Chromosome"]
	if !ok { return data, fmt.Errorf("Error: column %s not found.", "chrom") }
	samplecol, ok := header["unique_id"]
	if !ok { return data, fmt.Errorf("Error: column %s not found.", "sample") }
	tissuecol, ok := header["tissue"]
	if !ok { return data, fmt.Errorf("Error: column %s not found.", "tissue") }

	for s.Scan() {
		pos, err := strconv.Atoi(s.Line()[poscol])
		if err != nil { return data, err }

		var freq float64
		var err1 error
		var err2 error
		var hits float64
		var count float64

		if use_hits {
			hits , err1 = strconv.ParseFloat(s.Line()[hitscol], 64)
			count , err2 = strconv.ParseFloat(s.Line()[countcol], 64)
			if count != 0 {
				freq = hits / count
			} else {
				freq = 0
			}
		} else {
			freq, err1 = strconv.ParseFloat(s.Line()[freqcol], 64)
		}
		if err1 == nil && err2 == nil && (s.Line()[tissuecol] == "blood" || s.Line()[tissuecol] == "Blood") {
			entry := data_entry {
				chrpos: chrpos {
					chrom: s.Line()[chromcol],
					pos: pos,
				},
				freq: freq,
				sample: s.Line()[samplecol],
				tissue: s.Line()[tissuecol],
			}
			data.entries = append(data.entries, entry)
		}
	}
	return data, nil
}

func pos_bloodmean(p *posentry) (err error) {
	p.bloodmean, err = stats.Mean(p.freqs)
	return err
}

func pos_bloodsd(p *posentry) (err error) {
	p.bloodsd, err = stats.StandardDeviation(p.freqs)
	return err
}

func IndexStrings(strings []string, match string) int {
	for i, v := range strings {
		if v == match {
			return i
		}
	}
	return -1
}

func print_updated_data(r io.Reader, cmap samplemap, o io.Writer) (err error) {
	s := fasttsv.NewScanner(r)
	w := fasttsv.NewWriter(o)
	defer w.Flush()

	var outline []string

	s.Scan()
	header := s.Line()
	w.Write(append(header, "samplemean", "samplesd"))

	samplecol := IndexStrings(header, "sample")
	if samplecol == -1 { return fmt.Errorf("Error: column %s not found.", "sample") }

	for s.Scan() {

		sample := s.Line()[samplecol]

		bloodmean := "NA"
		bloodsd := "NA"
		bloodvals, ok := cmap[sample]
		if ok {
			bloodmean = fmt.Sprintf("%g", bloodvals.bloodmean)
			bloodsd = fmt.Sprintf("%g", bloodvals.bloodsd)
		}

		outline = append(outline[:0], s.Line()...)
		outline = append(outline, bloodmean, bloodsd)
		w.Write(outline)
	}
	return nil
}

func bloodmean_all(p samplemap) (err error) {
	for _, vals := range p {
		err = pos_bloodmean(vals)
		if err != nil { return err }
	}
	return nil
}

func bloodsd_all(p samplemap) (err error) {
	for _, vals := range p {
		err = pos_bloodsd(vals)
		if err != nil { return err }
	}
	return nil
}

func get_data(datapath *string, use_hits *bool, use_count *bool) (data dataframe, err error) {
	var dataconn *gzip.Reader
	if *datapath == "" { panic(fmt.Errorf("Error: no input path.")) }
	datafileconn, err := os.Open(*datapath)
	if err != nil { return }
	dataconn, err = gzip.NewReader(datafileconn)
	if err != nil { return }
	data, err = parse_data(dataconn, *use_hits, *use_count)
	if err != nil { return }
	dataconn.Close()
	datafileconn.Close()
	return data, err
}

func main() {
	datapath := flag.String("i", "", "input data path")
	use_hits := flag.Bool("H", false, "Use fraction of hits over counts (for Illumina allele frequency data.")
	use_count := flag.Bool("c", false, "Use count (for Illumina coverage data.")
	flag.Parse()

	data, err := get_data(datapath, use_hits, use_count)
	if err != nil { panic(err) }

	sample_map := mapit(data)
	bloodmean_all(sample_map)
	bloodsd_all(sample_map)

	datafileconn, err := os.Open(*datapath)
	if err != nil { panic(err) }
	defer datafileconn.Close()

	dataconn, err := gzip.NewReader(datafileconn)
	if err != nil { panic(err) }
	defer dataconn.Close()

	print_updated_data(dataconn, sample_map, os.Stdout)
}
