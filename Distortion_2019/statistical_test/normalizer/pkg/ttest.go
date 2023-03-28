package normalizer

import (
	"encoding/csv"
	"regexp"
	"strconv"
	"io"
	"fmt"
	"math"
	"gonum.org/v1/gonum/stat/distuv"
)

type TSummary struct {
	NamedValSet
	SumSqs map[string]float64
}

func (s *TSummary) Add(val float64, id string) {
	if !math.IsNaN(val) {
		s.NamedValSet.Add(val, id)
		s.SumSqs[id] += val * val
	}
}

func (s *TSummary) Var(id string) float64 {
	mean := s.Mean(id)
	vari := (s.SumSqs[id] / s.Counts[id]) - (mean * mean)
	return vari
}

func (s *TSummary) Sd(id string) float64 {
	vari := s.Var(id)
	return math.Sqrt(vari)
}

func NewTSummary() *TSummary {
	s := &TSummary{}
	s.Sums = make(map[string]float64)
	s.Counts = make(map[string]float64)
	s.SumSqs = make(map[string]float64)
	return s
}

func CalcTSummary(path string, valcol int, idcolsnames []string, idcols []int, controlsetidx, testsetidx int) ([]*TSummary, []TTestSet, error) {
	h := handle("CalcTSummary: %w")

	cr, gr, r, e := Open(path)
	if e != nil { return nil, nil, h(e) }
	defer r.Close()
	defer gr.Close()

	return CalcTSummaryFromCsvReader(cr, valcol, idcolsnames, idcols, controlsetidx, testsetidx)
}

func CalcTSummaryFromCsvReader(cr *csv.Reader, valcol int, idcolsnames []string, idcols []int, controlsetidx, testsetidx int) ([]*TSummary, []TTestSet, error) {
	h := handle("CalcTSummaryFromCsvReader: %w")

	var tsums []*TSummary
	for i, idcol := range idcols {
		tsum := NewTSummary()
		tsum.ColName = idcolsnames[i]
		tsum.Idx = idcol
		tsums = append(tsums, tsum)
	}

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return tsums, nil, h(e) }

		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		for _, tsum := range tsums {
			if len(line) <= tsum.Idx { continue }
			tsum.Add(val, line[tsum.Idx])
		}
	}

	tsets := []TTestSet{}
	for name, _ := range tsums[testsetidx].Counts {
		tsets = append(tsets, TTestSet{
			TTestItem{idcolsnames[controlsetidx], "blood"},
			TTestItem{idcolsnames[testsetidx], name},
		})
	}

	return tsums, tsets, nil
}

func CalcTSummaryVsBlood(path string, valcol int, idcolsnames []string, idcols []int, bloodcol int, bloodcolname string) (idtsums []*TSummary, bloodtsum *TSummary, err error) {
	h := handle("CalcTSummaryVsBlood: %w")

	var tsums []*TSummary
	for i, idcol := range idcols {
		tsum := NewTSummary()
		tsum.ColName = idcolsnames[i]
		tsum.Idx = idcol
		tsums = append(tsums, tsum)
	}

	bloodtsum = NewTSummary()
	bloodtsum.ColName = bloodcolname
	bloodtsum.Idx = bloodcol
	bloodre := regexp.MustCompile(`^[Bb]lood$`)

	cr, gr, r, e := Open(path)
	if e != nil { return nil, nil, h(e) }
	defer r.Close()
	defer gr.Close()

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return tsums, nil, h(e) }

		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		for _, tsum := range tsums {
			if len(line) <= tsum.Idx { continue }
			tsum.Add(val, line[tsum.Idx])
		}

		if len(line) <= bloodtsum.Idx { continue }
		bname := "notblood"
		if bloodre.MatchString(line[bloodtsum.Idx]) {
			bname = "blood"
		}
		bloodtsum.Add(val, bname)
	}

	return tsums, bloodtsum, nil
}

type TTestItem struct {
	ColName string
	Val string
}

type TTestSet struct {
	Control TTestItem
	Exp TTestItem
}

func TTestCore(mean1, mean2, sd1, sd2, count1, count2 float64) float64 {
	num := mean1 - mean2
	rt := ((sd1 * sd1) / count1) * ((sd2 * sd2) / count2)
	den := math.Sqrt(rt)
	return num / den
}

func TTestP(t float64, df float64) float64 {
	if BadDF(df) {
		return math.NaN()
	}
	tdist := distuv.StudentsT{Mu: 0, Sigma: 1, Nu: df}
	cdf := tdist.CDF(t)
	if cdf > 0.5 {
		return 2 * (1 - cdf)
	}
	return 2 * cdf
}

func TsumsSet(tsums []*TSummary, item TTestItem) (int, string) {
	for i, tsum := range tsums {
		if tsum.ColName == item.ColName {
			return i, item.Val
		}
	}
	panic(fmt.Errorf("TsumsSet: missing set %v", item))
	return 0, ""
}

func TTestDf(ts1 *TSummary, id1 string, ts2 *TSummary, id2 string) float64 {
	return ts1.Counts[id1] + ts2.Counts[id2] - 2
}

func TTest(w io.Writer, tsums []*TSummary, testset TTestSet) error {
	i1, name1 := TsumsSet(tsums, testset.Control)
	i2, name2 := TsumsSet(tsums, testset.Exp)

	mean1 := tsums[i1].Mean(name1)
	mean2 := tsums[i2].Mean(name2)

	sd1 := tsums[i1].Sd(name1)
	sd2 := tsums[i2].Sd(name2)

	count1 := tsums[i1].Counts[name1]
	count2 := tsums[i2].Counts[name2]

	df := TTestDf(tsums[i1], name1, tsums[i2], name2)

	t := TTestCore(mean1, mean2, sd1, sd2, count1, count2)
	p := TTestP(t, df)

	fmt.Fprintf(w, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\n", name1, name2, count1, count2, mean1, mean2, sd1, sd2, t, df, df, p)

	return nil
}

func TTests(w io.Writer, tsums []*TSummary, testsets []TTestSet) error {
	for _, tset := range testsets {
		e := TTest(w, tsums, tset)
		if e != nil {
			return fmt.Errorf("TTests: %w", e)
		}
	}
	return nil
}

func RunTTest(path string, w io.Writer, valcolname string, idcolsnames []string, controlsetidx, testsetidx int) error {
	h := handle("Run: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	idcols, e := IdCols(path, idcolsnames)
	if e != nil { return h(e) }

	tsummaries, testsets, e := CalcTSummary(path, valcol, idcolsnames, idcols, controlsetidx, testsetidx)
	if e != nil { return h(e) }

	e = TTests(w, tsummaries, testsets)
	if e != nil { return h(e) }

	return nil
}

func RunFullTTest(path string, w io.Writer, valcolname, bloodcolname, testcolname string) error {
	idcolsnames := []string{bloodcolname, testcolname}
	return RunTTest(path, w, valcolname, idcolsnames, 0, 1)
}
