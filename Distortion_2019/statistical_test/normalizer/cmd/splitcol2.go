package main

import (
	"encoding/csv"
	"os"
	"io"
	"strings"
)

func main() {
	cr := csv.NewReader(os.Stdin)
	cr.Comma = rune('\t')
	cr.LazyQuotes = true
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true

	cw := csv.NewWriter(os.Stdout)
	cw.Comma = rune('\t')
	defer cw.Flush()

	for l, e := cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { panic(e) }
		s := strings.Split(l[1], "_")
		l = append(l, s...)
		e = cw.Write(l)
		if e != nil { panic(e) }
	}
}
