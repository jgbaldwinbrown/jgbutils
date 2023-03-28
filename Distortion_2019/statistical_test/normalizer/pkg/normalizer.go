package normalizer

import (
	"math"
	"strconv"
	"encoding/csv"
	"compress/gzip"
	"io"
	"os"
	"fmt"
)

func handle(form string) func(...any) error {
	return func(args ...any) error {
		return fmt.Errorf(form, args...)
	}
}

type NamedValSet struct {
	ColName string
	Idx int
	Names []string
	Sums map[string]float64
	Counts map[string]float64
}

func (s *NamedValSet) Mean(id string) float64 {
	return s.Sums[id] / s.Counts[id]
}

func OpenCsv(r io.Reader) (*csv.Reader) {
	cr := csv.NewReader(r)
	cr.Comma = rune('\t')
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true
	cr.LazyQuotes = true
	return cr
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

	cr := OpenCsv(gr)

	return cr, gr, f, nil
}

func NamedCols(path string, names []string) ([]int, error) {
	h := handle("NamedCols: %w")

	cr, gr, r, e := Open(path)
	if e != nil { return nil, h(e) }
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
		return nil, h(fmt.Errorf("len(idxs) %v != len(names) %v", len(idxs), len(names)))
	}

	return idxs, nil
}

func ValCol(path, valname string) (int, error) {
	h := handle("ValCol: %w")

	cols, e := NamedCols(path, []string{valname})
	if e != nil { return 0, h(e) }

	return cols[0], nil
}

func IdCols(path string, idnames []string) ([]int, error) {
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

	cr, gr, fp, e := Open(path)
	if e != nil { return nil, h(e) }
	defer fp.Close()
	defer gr.Close()

	sets := []*NamedValSet{}
	for i, name := range idnames {
		s := NewNamedValSet()
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

func (s *NamedValSet) Add(val float64, id string) {
	if !math.IsNaN(val) {
		s.Sums[id] += val
		s.Counts[id]++
	}
}

func (s *NamedValSet) AddResid(val float64, line []string, means []*NamedValSet, id string) {
	resid := val
	for _, mean := range means {
		resid -= mean.Mean(line[mean.Idx])
	}
	s.Add(resid, id)
}

func CalcSerialMean(path string, valcol int, means []*NamedValSet, idname string, idcol int) (*NamedValSet, error) {
	h := handle("CalcSerialMean: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return nil, h(e) }
	defer fp.Close()
	defer gr.Close()

	s := NewNamedValSet()
	s.ColName = idname
	s.Idx = idcol

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return s, h(e) }

		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		if len(line) <= s.Idx { continue }
		s.AddResid(val, line, means, line[s.Idx])
	}

	return s, nil
}

func CalcSerialMeans(path string, valcol int, idnames []string, idcols []int) ([]*NamedValSet, error) {
	h := handle("CalcSerialMeans: %w")

	var means []*NamedValSet
	for i, name := range idnames {
		mean, e := CalcSerialMean(path, valcol, means, name, idcols[i])
		if e != nil { return nil, h(e) }
		means = append(means, mean)
	}
	return means, nil
}

func NormOne(line []string, valcol int, means []*NamedValSet) (float64, error) {
	h := handle("NormOne: %w")

	if len(line) <= valcol { return 0, h(fmt.Errorf("line too short")) }
	val, e := strconv.ParseFloat(line[valcol], 64)
	if e != nil { return 0, h(e) }

	resid := val

	for _, mean := range means {
		if len(line) <= mean.Idx { return 0, h(fmt.Errorf("line too short")) }
		resid -= mean.Mean(line[mean.Idx])
	}
	return resid, nil
}

func Norm(path string, w io.Writer, valcol int, means []*NamedValSet) error {
	h := handle("Norm: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return h(e) }
	defer fp.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	line, e := cr.Read()
	if e != nil { return h(e) }
	line = append(line, "norm")
	e = cw.Write(line)
	if e != nil { return h(e) }

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }

		norm, e := NormOne(line, valcol, means)
		if e != nil { continue }
		line = append(line, fmt.Sprintf("%f", norm))
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func Run(path string, w io.Writer, valcolname string, idcolsnames []string) error {
	h := handle("Run: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	idcols, e := IdCols(path, idcolsnames)
	if e != nil { return h(e) }

	means, e := CalcSerialMeans(path, valcol, idcolsnames, idcols)
	if e != nil { return h(e) }

	e = Norm(path, w, valcol, means)
	if e != nil { return h(e) }

	return nil
}
