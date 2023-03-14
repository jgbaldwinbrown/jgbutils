package main

import (
	"encoding/csv"
	"compress/gzip"
	"math"
	"github.com/montanaflynn/stats"
	"io"
	"os"
	"flag"
	"fmt"
)

func handle(form string) func(...any) error {
	return func(args ...any) {
		return fmt.Errorf(form, args)
	}
}

type NamedValSet struct {
	ColName string
	Idx int
	Names []string
	Sums map[string]float64
	Counts map[string]float64
}

func Open(path string) (*csv.Reader, *gzip.Reader, *os.File, error) {
	h := handle("Open: %w")

	f, e := os.Open(path)
	if e != nil { return nil, nil, nil, h(e) }

	gr, e := gzip.NewReader(f)
	if e != nil {
		f.Close()
		return nil, nil, nil, h(e)
	}

	cr := csv.NewReader(gr)
	cr.Comma = rune('\t')
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true
	cr.LazyQuotes = true

	return cr, gr, f, nil
}

func NamedCols(path string, names []string) ([]int, error) {
	h := handle("NamedCols: %w")

	cr, gr, r, e := Open(path)
	if e { return nil, h(e) }
	defer r.Close()
	defer gr.Close()

	line, e := cr.Read()
	if e != nil { return nil, h(e) }

	var idxs []int

	for _, name := range names {
		for i, col := range line {
			if name == col {
				idxs = append(idxs, i)
				break
			}
		}
	}

	if len(idxs) != len(names) {
		return nil, h(fmt.Errorf("len(idxs) %v != len(names) %v", len(idxs), len(names))
	}

	return idxs, nil
}

func ValCol(path, valname string) (int, error) {
	h := handle("ValCol: %w")

	cols, e := NamedCols(path, []string{valname})
	if e != nil { return 0, h(e) }

	return cols[0], nil
}

func IdCols(path, idnames []string) ([]int, error) {
	return NamedCols(path, idnames)
}

func NewNamedValSet() *NamedValSet {
	s := new(NamedValSet)
	s.Sums = make(map[string]float64)
	s.Counts = make(map[string]float64)
	return s
}

func CalcMeans(path string, valcol int, idnames []string, idcols []int) ([]*NamedValSet, error) {
	h := handle("CalcMeans: %w")

	cr, gr, fp, e := Open(inpath)
	if e { return h(e) }
	defer fp.Close()
	defer gr.Close()

	sets := []*NamedValSet{}
	for i, name := range idnames {
		set := NewNamedValSet()
		s.ColName = name
		s.Idx = idcols[i]
		sets = append(sets, s)
	}

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return sets, h(e) }

		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		for _, set := range sets {
			if len(line) <= set.Idx { continue }
			set.Add(val, line[set.Idx])
		}
	}

	return sets, nil
}

func Norm(path string, w io.Writer, valcol int, means []*NamedValSet) error {
	
}

func Run(path string, w io.Writer, valcolname string, idcolsnames []string) error {
	h := handle("Run: %w")

	valcol, e := ValCol(path)
	if e != nil { return h(e) }

	idcols, e := IdCols(path)
	if e != nil { return h(e) }

	means, e := CalcMeans(path, valcol, idcolsnames, idcols)
	if e != nil { return h(e) }

	e := Norm(path, w, valcol, means)
	if e != nil { return h(e) }

	return nil
}

func main() {
	inpp := flag.String("i", "", "input .gz file")
	valcolp := flag.String("v", "", "value column name")
	idcolsp := flag.String("id", "", "id column names, comma-separated")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *valcolp == "" {
		panic(fmt.Errorf("missing -v"))
	}
	if *idcolsp == "" {
		panic(fmt.Errorf("missing -id"))
	}

	idcols := strings.Split(*idcolsp, ",")
	if len(idcols) < 1 {
		panic(fmt.Errorf("could not parse -id %v", *idcolsp))
	}

	e := Run(*inpp, os.Stdout)
	if e != nil { panic(e) }
}
