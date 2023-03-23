package normalizer

import (
	"strconv"
	"fmt"
	"io"
	"encoding/csv"
)

func AddAfracOne(line []string, hitcol, countcol int) (float64, error) {
	h := handle("CombineOne: %w")

	if len(line) <= hitcol { return 0, h(fmt.Errorf("line too short")) }
	hits, e := strconv.ParseFloat(line[hitcol], 64)
	if e != nil { return 0, h(e) }

	if len(line) <= countcol { return 0, h(fmt.Errorf("line too short")) }
	count, e := strconv.ParseFloat(line[countcol], 64)
	if e != nil { return 0, h(e) }

	return hits / count, nil
}

func AddAfrac(path string, w io.Writer, hitcol, countcol int) error {
	h := handle("AddAfrac: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return h(e) }
	defer fp.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	line, e := cr.Read()
	if e != nil { return h(e) }
	line = append(line, "value")
	e = cw.Write(line)
	if e != nil { return h(e) }

	for line, e = cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }

		combined, e := AddAfracOne(line, hitcol, countcol)
		if e != nil { continue }
		line = append(line, fmt.Sprint(combined))
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func RunAddAfrac(path string, w io.Writer, hitcolname, countcolname string) error {
	h := handle("RunAddAfrac: %w")

	hitcol, e := ValCol(path, hitcolname)
	if e != nil { return h(e) }

	countcol, e := ValCol(path, countcolname)
	if e != nil { return h(e) }

	e = AddAfrac(path, w, hitcol, countcol)
	if e != nil { return h(e) }

	return nil
}
