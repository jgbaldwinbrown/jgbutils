package normalizer

import (
	"encoding/csv"
	"strconv"
	"math"
	"fmt"
	"io"
)
func CalcTSummaryTransform(path string, valcol int, idcolsnames []string, idcols []int, transformFunc func(string) float64) ([]*TSummary, error) {
	h := handle("CalcTSummaryTransform: %w")

	cr, gr, r, e := Open(path)
	if e != nil { return nil, h(e) }
	defer r.Close()
	defer gr.Close()

	return CalcTSummaryTransformFromCsvReader(cr, valcol, idcolsnames, idcols, transformFunc)
}

func CalcTSummaryTransformFromCsvReader(
	cr *csv.Reader,
	valcol int,
	idcolsnames []string,
	idcols []int,
	transformFunc func(string) float64,
) ([]*TSummary, error) {
	h := handle("CalcTSummaryTransformFromCsvReader: %w")

	var tsums []*TSummary
	for i, idcol := range idcols {
		tsum := NewTSummary()
		tsum.ColName = idcolsnames[i]
		tsum.Idx = idcol
		tsums = append(tsums, tsum)
	}

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return tsums, h(e) }

		if len(line) <= valcol { continue }
		val := transformFunc(line[valcol])

		for _, tsum := range tsums {
			if len(line) <= tsum.Idx { continue }
			name := line[tsum.Idx]
			if !tsum.MeanOk(name) {
				tsum.Names = append(tsum.Names, name)
			}
			tsum.Add(val, name)
		}
	}

	return tsums, nil
}


func CalcFullColTSummaryTransform(path string, cols []int, transformFunc func(string) float64) ([]*TSummary, error) {
	h := handle("CalcTSummaryTransform: %w")

	var tsums []*TSummary
	for _, col := range cols {
		tsum := NewTSummary()
		tsum.Idx = col
		tsums = append(tsums, tsum)
	}

	cr, gr, r, e := Open(path)
	if e != nil { return nil, h(e) }
	defer r.Close()
	defer gr.Close()

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return tsums, h(e) }


		for i, tsum := range tsums {
			valcol := cols[i]
			if len(line) <= valcol { continue }
			val := transformFunc(line[valcol])

			tsum.Add(val, "")
		}
	}

	return tsums, nil
}

func LinearModelCoreMulti(path string, valcol, indepcol, categorycol int, names []string, vmeans []float64, imeans []float64) (stats []Stats, err error) {
	return LinearModelTransformCoreMulti(path, valcol, indepcol, categorycol, names, vmeans, imeans, MustParseFloat)
}

func LinearModelTransformCoreMulti(path string, valcol, indepcol, categorycol int, names []string, vmeans []float64, imeans []float64, transformFunc func(string) float64) (stats []Stats, err error) {
	h := handle("LinearModelCore: %w")

	modelers := map[string]*LinearModeler{}
	for i, name := range names {
		modelers[name] = &LinearModeler{XMean: imeans[i], YMean: vmeans[i]}
	}

	cr, gr, r, e := Open(path)
	if e != nil { return nil, h(e) }
	defer r.Close()
	defer gr.Close()

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return nil, h(e) }


		if len(line) <= valcol { continue }
		val := transformFunc(line[valcol])

		if len(line) <= indepcol { continue }
		indep := transformFunc(line[indepcol])

		if len(line) <= categorycol { continue }
		modeler, ok := modelers[line[categorycol]]
		if !ok { continue }
		// fmt.Fprintf(os.Stderr, "adding: val: %v; indep: %v\n", val, indep)
		modeler.Add(val, indep)
	}

	for _, name := range names {
		modeler, ok := modelers[name]
		if !ok { continue }
		// fmt.Fprintf(os.Stderr, "name: %v; modeler: %v\n", name, *modeler)
		m_out, b_out := modeler.MB()
		// fmt.Fprintf(os.Stderr, "m: %v; b: %v\n", m_out, b_out)
		stats = append(stats, Stats{name, m_out, b_out})
	}

	return stats, nil

}

func LinearModelTransform(path string, valcol, indepcol int, transformFunc(func(string)float64)) (m, b float64, err error) {
	h := handle("LinearModel: %w")

	valtsums, e := CalcFullColTSummaryTransform(path, []int{valcol}, transformFunc)
	indeptsums, e := CalcFullColTSummary(path, []int{indepcol})
	if e != nil { return 0, 0, h(e) }
	vmean := valtsums[0].Mean("")
	imean := indeptsums[0].Mean("")

	m, b, e = LinearModelTransformCore(path, valcol, indepcol, vmean, imean, transformFunc)
	if e != nil { return 0, 0, h(e) }
	return m, b, nil
}

type Stats struct {
	Name string
	M float64
	B float64
}

func LinearModelTransformCategory(path string, valcol, indepcol, categorycol int, transformFunc(func(string)float64)) (stats []Stats, err error) {
	h := handle("LinearModel: %w")

	valtsums, e := CalcTSummaryTransform(path, valcol, []string{""}, []int{categorycol}, transformFunc)
	indeptsums, _, e := CalcTSummary(path, indepcol, []string{""}, []int{categorycol}, 0, 0)
	if e != nil { return nil, h(e) }

	var names []string
	var vmeans []float64
	var imeans []float64
	for _, name := range valtsums[0].Names {
		ok1 := valtsums[0].MeanOk(name)
		ok2 := indeptsums[0].MeanOk(name)
		if !ok1 || !ok2 {
			stats = append(stats, Stats{name, math.NaN(), math.NaN()})
			continue
		}
		vmean := valtsums[0].Mean(name)
		imean := indeptsums[0].Mean(name)
		names = append(names, name)
		vmeans = append(vmeans, vmean)
		imeans = append(imeans, imean)
	}

	newstats, e := LinearModelTransformCoreMulti(path, valcol, indepcol, categorycol, names, vmeans, imeans, transformFunc)
	if e != nil { return nil, h(e) }

	stats = append(stats, newstats...)
	return stats, nil
}

var sexChroms = map[string]struct{} {
	"X": struct{}{},
	"Y": struct{}{},
	"x": struct{}{},
	"y": struct{}{},
	"NC_000023.11": struct{}{},
	"NC_000024.10": struct{}{},
}

func IsSexChr(chr string) bool {
	_, ok := sexChroms[chr]
	return ok
}

func ChrToExpectation(chr string) float64 {
	chrcov := 1.0
	if IsSexChr(chr) {
		chrcov = 0.5
	}
	return chrcov
}

func GenotypeToExpectation(chr string) float64 {
	f, e := strconv.ParseFloat(chr, 64)
	if e != nil {
		return math.NaN()
	}
	return f
}

func PrintStats(w io.Writer, stats []Stats) error {
	h := handle("PrintStats: %w")

	for _, stat := range stats {
		_, e := fmt.Fprintf(w, "%v\t%v\t%v\n", stat.Name, stat.B, stat.M)
		if e != nil { return h(e) }
	}
	return nil
}

func RunLinearModelCoverage(path string, w io.Writer, valcolname, indepcolname, categoryColName string, het bool) error {
	h := handle("RunLinearModel: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	indepcol, e := ValCol(path, indepcolname)
	if e != nil { return h(e) }


	var m, b float64
	if !het {
		m, b, e = LinearModelTransform(path, valcol, indepcol, ChrToExpectation)
		if e != nil { return h(e) }

		fmt.Fprintf(w, "allchromtotals\t%v\t%v\n", b, m)
	} else {

		categorycol, e := ValCol(path, categoryColName)
		if e != nil { return h(e) }

		stats, e := LinearModelTransformCategory(path, valcol, indepcol, categorycol, GenotypeToExpectation)
		if e != nil { return h(e) }

		e = PrintStats(w, stats)
		if e != nil { return h(e) }
	}

	return nil
}
