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

type posmap map[chrpos]*posentry

func mapit(d dataframe) (cmap posmap) {
	cmap = make(posmap)
	for _, e := range d.entries {
		if e.tissue == "blood" || e.tissue == "Blood" {
			vals, ok := cmap[e.chrpos]
			if ! ok {
				cmap[e.chrpos] = new(posentry)
				vals = cmap[e.chrpos]
			}
			vals.freqs = append(vals.freqs, e.freq)
		}
	}
	return cmap
}

func parse_data(r io.Reader, use_hits bool, use_count bool) (data dataframe, err error) {
	s := fasttsv.NewScanner(r)
	s.Scan()

	header := make(map[string]int)
	for i, v := range s.Line() {
		header[v] = i
	}

	var hitscol int
	var countcol int
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

func print_updated_data(r io.Reader, cmap posmap, o io.Writer) (err error) {
	s := fasttsv.NewScanner(r)
	w := fasttsv.NewWriter(o)
	defer w.Flush()

	var outline []string
	var c chrpos

	s.Scan()

	headerline := make([]string, len(s.Line()))
	copy(headerline, s.Line())
	headerline = append(headerline, "bloodmean", "bloodsd")
	w.Write(headerline)
	header := make(map[string]int)
	for i, v := range s.Line() {
		header[v] = i
	}

	poscol, ok := header["Position"]
	if !ok { return fmt.Errorf("Error: column %s not found.", "col") }
	chromcol, ok := header["Chromosome"]
	if !ok { return fmt.Errorf("Error: column %s not found.", "chrom") }

	for s.Scan() {
		c.chrom = s.Line()[chromcol]

		var err error
		c.pos, err = strconv.Atoi(s.Line()[poscol])
		if err != nil { return fmt.Errorf("Error: pos %s could not be converted to integer.", s.Line()[poscol]) }

		outline = outline[:0]
		outline = append(outline, s.Line()...)

		bloodmean := "NA"
		bloodsd := "NA"
		bloodvals, ok := cmap[c]
		if ok {
			bloodmean = fmt.Sprintf("%g", bloodvals.bloodmean)
			bloodsd = fmt.Sprintf("%g", bloodvals.bloodsd)
		}
		outline = append(outline, bloodmean, bloodsd)
		w.Write(outline)
	}
	return nil
}

func bloodmean_all(p posmap) (err error) {
	for _, vals := range p {
		err = pos_bloodmean(vals)
		if err != nil { return err }
	}
	return nil
}

func bloodsd_all(p posmap) (err error) {
	for _, vals := range p {
		err = pos_bloodsd(vals)
		if err != nil { return err }
	}
	return nil
}

func main() {
	datapath := flag.String("i", "", "input data path")
	use_hits := flag.Bool("H", false, "Use fraction of hits over counts (for Illumina allele frequency data.")
	use_count := flag.Bool("c", false, "Use count (for Illumina coverage data.")
	flag.Parse()

	var dataconn *gzip.Reader
	if *datapath == "" { panic(fmt.Errorf("Error: no input path.")) }
	datafileconn, err := os.Open(*datapath)
	if err != nil { panic(err) }
	dataconn, err = gzip.NewReader(datafileconn)
	if err != nil { panic(err) }
	data, err := parse_data(dataconn, *use_hits, *use_count)
	if err != nil { panic(err) }
	dataconn.Close()
	datafileconn.Close()

	chrpos_map := mapit(data)
	bloodmean_all(chrpos_map)
	bloodsd_all(chrpos_map)

	datafileconn, err = os.Open(*datapath)
	if err != nil { panic(err) }
	dataconn, err = gzip.NewReader(datafileconn)
	if err != nil { panic(err) }
	defer dataconn.Close()
	defer datafileconn.Close()

	print_updated_data(dataconn, chrpos_map, os.Stdout)
}
