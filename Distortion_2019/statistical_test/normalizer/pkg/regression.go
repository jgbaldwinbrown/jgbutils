package normalizer

import (
	"encoding/csv"
	"fmt"
	"io"
	"strconv"
)

func CalcFullColTSummary(path string, cols []int) ([]*TSummary, error) {
	h := handle("CalcTSummary: %w")

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
			val, e := strconv.ParseFloat(line[valcol], 64)
			if e != nil { continue }

			if len(line) <= tsum.Idx { continue }
			tsum.Add(val, "")
		}
	}

	return tsums, nil
}

type LinearModeler struct {
	XDiffYDiffSum float64
	XDiffSqSum float64
	Count float64
	XMean float64
	YMean float64
}

func (m *LinearModeler) Add(y, x float64) {
	xdiff := x - m.XMean
	ydiff := y - m.YMean
	m.XDiffSqSum += xdiff * xdiff
	m.XDiffYDiffSum += xdiff * ydiff
	m.Count++
}

func (l *LinearModeler) MB() (m float64, b float64) {
	m = l.XDiffYDiffSum / l.XDiffSqSum
	b = l.YMean - (m * l.XMean)
	return m, b
}

func LinearModelCore(path string, valcol, indepcol int, vmean, imean float64) (m, b float64, err error) {
	h := handle("LinearModelCore: %w")

	l := &LinearModeler{XMean: imean, YMean: vmean}

	cr, gr, r, e := Open(path)
	if e != nil { return 0, 0, h(e) }
	defer r.Close()
	defer gr.Close()

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return 0, 0, h(e) }


		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		if len(line) <= indepcol { continue }
		indep, e := strconv.ParseFloat(line[indepcol], 64)
		if e != nil { continue }

		l.Add(val, indep)
	}

	m_out, b_out := l.MB()
	return m_out, b_out, nil

}

func LinearModel(path string, valcol, indepcol int) (m, b float64, err error) {
	h := handle("LinearModel: %w")

	tsums, e := CalcFullColTSummary(path, []int{valcol, indepcol})
	if e != nil { return 0, 0, h(e) }
	vmean := tsums[0].Mean("")
	imean := tsums[1].Mean("")

	m, b, e = LinearModelCore(path, valcol, indepcol, vmean, imean)
	if e != nil { return 0, 0, h(e) }
	return m, b, nil
}

func OneLinearModelResidual(y, x, m, b float64) float64 {
	predict := (x * m) + b
	return y - predict
}

func LinearModelResiduals(path string, w io.Writer, valcol, indepcol int, m, b float64) (err error) {
	h := handle("LinearModelResiduals: %w")

	cr, gr, r, e := Open(path)
	if e != nil { return h(e) }
	defer r.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	line, e := cr.Read()
	if e != nil { return h(e) }
	line = append(line, "residual")
	e = cw.Write(line)
	if e != nil { return h(e) }

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }


		if len(line) <= valcol { continue }
		val, e := strconv.ParseFloat(line[valcol], 64)
		if e != nil { continue }

		if len(line) <= indepcol { continue }
		indep, e := strconv.ParseFloat(line[indepcol], 64)
		if e != nil { continue }

		resid := OneLinearModelResidual(val, indep, m, b)
		line = append(line, fmt.Sprint(resid))
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func RunLinearModel(path string, w io.Writer, valcolname, indepcolname string) error {
	h := handle("RunLinearModel: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	indepcol, e := ValCol(path, indepcolname)
	if e != nil { return h(e) }

	m, b, e := LinearModel(path, valcol, indepcol)
	if e != nil { return h(e) }

	e = LinearModelResiduals(path, w, valcol, indepcol, m, b)
	if e != nil { return h(e) }

	return nil
}

/*
b = y_bar - m * x_bar

m = sum_i((x_i - x_bar) * (y_i - y_bar)) / sum_i((x_i - x_bar)^2)

/*
simpleLinearRegression :: Fractional a => [(a, a)] -> (a, a)
simpleLinearRegression points =
    (slope, intercept)
    where
    avg (x, y) = (Sum 1, Sum x, Sum y)

    reg (x, y) (avg_x, avg_y) =
        (Sum $ x' * y', Sum $ x' * x')
        where
        x' = x - avg_x
        y' = y - avg_y

    ((Sum n, Sum xs, Sum ys), getReg) = foldMap (\p -> (avg p, reg p)) points

    avg_x = xs / n
    avg_y = ys / n
    (Sum xys, Sum xxs) = getReg (avg_x, avg_y)
    slope = xys / xxs
    intercept = avg_y - slope * avg_x
*/

/*
-- naive-linear-regression.hs
import Data.Maybe (mapMaybe)

main :: IO ()
main =
    print . simpleLinearRegression . parse =<< getContents

readM :: Read a => String -> Maybe a
readM str =
    case reads str of
        [(x, "")] -> Just x
        _ -> Nothing

parse :: String -> [(Double, Double)]
parse =
    mapMaybe parseLine . lines . filter (/= '\r')
    where
    parseLine raw =
        let (x, y) = break (== ',') raw
        in (,) <$> readM x <*> readM (tail y)

simpleLinearRegression :: Fractional a => [(a, a)] -> (a, a)
simpleLinearRegression points =
    (slope, intercept)
    where
    avg_x = sum [x | (x, _) <- points] / fromIntegral (length points)
    avg_y = sum [y | (_, y) <- points] / fromIntegral (length points)

    xys = sum [(x - avg_x) * (y - avg_y) | (x, y) <- points]
    xxs = sum [(x - avg_x) * (x - avg_x) | (x, _) <- points]

    slope = xys / xxs
    intercept = avg_y - slope * avg_x
*/
