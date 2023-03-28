package normalizer

import (
	"fmt"
	"io"
)

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

			if len(line) <= tsum.Idx { continue }
			tsum.Add(val, "")
		}
	}

	return tsums, nil
}

func LinearModelTransform(path string, valcol, indepcol int, transformFunc(func(string)float64)) (m, b float64, err error) {
	h := handle("LinearModel: %w")

	valtsums, e := CalcFullColTSummaryTransform(path, []int{valcol}, transformFunc)
	indeptsums, e := CalcFullColTSummary(path, []int{indepcol})
	if e != nil { return 0, 0, h(e) }
	vmean := valtsums[0].Mean("")
	imean := indeptsums[0].Mean("")

	m, b, e = LinearModelCore(path, valcol, indepcol, vmean, imean)
	if e != nil { return 0, 0, h(e) }
	return m, b, nil
}

func ChrToExpectation(chr string) float64 {
	chrcov := 1.0
	if chr == "X" || chr == "Y" || chr == "x" || chr == "y" {
		chrcov = 0.5
	}
	return chrcov
}

func RunLinearModelCoverage(path string, w io.Writer, valcolname, indepcolname string) error {
	h := handle("RunLinearModel: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	indepcol, e := ValCol(path, indepcolname)
	if e != nil { return h(e) }

	m, b, e := LinearModelTransform(path, valcol, indepcol, ChrToExpectation)
	if e != nil { return h(e) }

	fmt.Fprintf(w, "allchromtotals\t%v\t%v\n", b, m)

	return nil
}
