package normalizer

import (
	"fmt"
	"strconv"
	"io"
	"encoding/csv"
)

func SubOne(line []string, valcol, tosubcol int) (float64, error) {
	h := handle("SubOne: %w")

	if len(line) <= valcol { return 0, h(fmt.Errorf("line too short")) }
	val, e := strconv.ParseFloat(line[valcol], 64)
	if e != nil { return 0, h(e) }

	if len(line) <= tosubcol { return 0, h(fmt.Errorf("line too short")) }
	tosub, e := strconv.ParseFloat(line[tosubcol], 64)
	if e != nil { return 0, h(e) }

	return val - tosub, nil
}

func ColSub(path string, w io.Writer, valcol, tosubcol int) error {
	h := handle("RunColSub: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return h(e) }
	defer fp.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	line, e := cr.Read()
	if e != nil { return h(e) }
	line = append(line, "sub")
	e = cw.Write(line)
	if e != nil { return h(e) }

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }

		subbed, e := SubOne(line, valcol, tosubcol)
		if e != nil { continue }
		line = append(line, fmt.Sprintf("%f", subbed))
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func RunColSub(path string, w io.Writer, valcolname, tosubcolname string) error {
	h := handle("RunColSub: %w")

	valcol, e := ValCol(path, valcolname)
	if e != nil { return h(e) }

	tosubcol, e := ValCol(path, tosubcolname)
	if e != nil { return h(e) }

	e = ColSub(path, w, valcol, tosubcol)
	if e != nil { return h(e) }

	return nil
}
