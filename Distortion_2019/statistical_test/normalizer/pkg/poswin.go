package normalizer

import (
	"strconv"
	"fmt"
	"io"
	"encoding/csv"
)

func PosWinOne(line []string, col int, winsize int) (int, error) {
	h := handle("CombineOne: %w")

	if len(line) <= col { return 0, h(fmt.Errorf("line too short")) }
	p, e := strconv.ParseInt(line[col], 0, 64)
	if e != nil { return 0, h(e) }

	return (int(p) / winsize) * winsize, nil
}

func PosWin(path string, w io.Writer, col int, winsize int) error {
	h := handle("PosWin: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return h(e) }
	defer fp.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	line, e := cr.Read()
	if e != nil { return h(e) }
	line = append(line, "poswin")
	e = cw.Write(line)
	if e != nil { return h(e) }

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }

		pw, e := PosWinOne(line, col, winsize)
		if e != nil { continue }
		line = append(line, fmt.Sprint(pw))
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func RunPosWin(path string, w io.Writer, colname string, winsize int) error {
	h := handle("RunColCombine: %w")

	cols, e := NamedCols(path, []string{colname})
	if e != nil { return h(e) }

	e = PosWin(path, w, cols[0], winsize)
	if e != nil { return h(e) }

	return nil
}
