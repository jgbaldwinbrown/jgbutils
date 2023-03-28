package normalizer

import (
	"strings"
	"fmt"
	"io"
	"encoding/csv"
)

func CombineOne(line []string, cols []int, sep string) (string, error) {
	h := handle("CombineOne: %w")

	tocombine := make([]string, 0, len(cols))

	for _, col := range cols {
		if len(line) <= col { return "", h(fmt.Errorf("line too short")) }
		tocombine = append(tocombine, strings.ReplaceAll(line[col], sep, "."))
	}

	return strings.Join(tocombine, sep), nil
}

func ColCombine(path string, w io.Writer, cols []int, sep string) error {
	h := handle("ColCombine: %w")

	cr, gr, fp, e := Open(path)
	if e != nil { return h(e) }
	defer fp.Close()
	defer gr.Close()

	cw := csv.NewWriter(w)
	cw.Comma = rune('\t')
	defer cw.Flush()

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return h(e) }

		combined, e := CombineOne(line, cols, sep)
		if e != nil { continue }
		line = append(line, combined)
		e = cw.Write(line)
		if e != nil { continue }
	}

	return nil
}

func RunColCombine(path string, w io.Writer, colnames []string, sep string) error {
	h := handle("RunColCombine: %w")

	cols, e := NamedCols(path, colnames)
	if e != nil { return h(e) }

	e = ColCombine(path, w, cols, sep)
	if e != nil { return h(e) }

	return nil
}
