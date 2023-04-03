package normalizer

import (
	"strings"
	"encoding/csv"
	"fmt"
	"flag"
	"os"
	"io"
	"strconv"
)

func ParseInfoLine(line []string, keycol int) (key string, err error) {
	h := handle("ParseExpSexLine: %w")

	if len(line) <= keycol {
		return "", h(fmt.Errorf("len(line) %v < keycol %v", len(line), keycol))
	}

	return line[keycol], nil
}

func GetInfoMap(path string, keycol int) (map[string][]string, error) {
	h := handle("GetExperimentSexInfo: %w")

	m := map[string][]string{}

	r, e := os.Open(path)
	if e != nil { return nil, h(e) }
	defer r.Close()

	cr := OpenCsv(r)
	cr.ReuseRecord = false

	for l, e := cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { return nil, h(e) }

		key, e := ParseInfoLine(l, keycol)
		if e != nil { return nil, h(e) }
		m[key] = l
	}
	return m, nil
}

func GetColsToAppend(line []string, m map[string][]string, keycol int, valcols []int) ([]string, error) {
	h := handle("GetExpSex: %w")

	if len(line) <= keycol {
		return nil, h(fmt.Errorf("len(line) %v < keycol %v", len(line), keycol))
	}


	idline, ok := m[line[keycol]]
	if !ok {
		return make([]string, len(valcols)), nil
	}

	var out []string
	for _, valcol := range valcols {
		if len(idline) <= valcol {
			return nil, h(fmt.Errorf("len(idline) %v < valcol %v", len(idline), valcol))
		}
		out = append(out, idline[valcol])
	}

	return out, nil
}

func AddIdCols(r io.Reader, w io.Writer, keycol int, idcolnames []string, idcols []int, infoMap map[string][]string) error {
	h := handle("RunTrueIdentity: %w")

	cr := OpenCsv(r)

	cw := csv.NewWriter(w)
	defer cw.Flush()
	cw.Comma = rune('\t')

	l, e := cr.Read()
	if e != nil { return h(e) }
	l = append(l, idcolnames...)
	e = cw.Write(l)
	if e != nil { return h(e) }

	for l, e = cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { return h(e) }

		newcols, e := GetColsToAppend(l, infoMap, keycol, idcols)
		if e != nil { return h(e) }
		l = append(l, newcols...)

		e = cw.Write(l)
		if e != nil { return h(e) }
	}

	return nil
}

func ParseValCols(str string) ([]int, error) {
	spl := strings.Split(str, ",")
	var out []int
	for _, vcstr := range spl {
		vc, e := strconv.Atoi(vcstr)
		if e != nil {
			return nil, fmt.Errorf("ParseValCols: %w", e)
		}
		out = append(out, vc)
	}
	return out, nil
}

func RunAddIdCols() {
	ipathp := flag.String("si", "", "path to sample ID file")
	idKeyColp := flag.Int("idkey", -1, "Key column in ID file")
	keyColp := flag.Int("key", -1, "Key column in data file")
	idValColsp := flag.String("valcols", "", "comma-separated columns in ID file to add")
	idValNamesp := flag.String("valnames", "", "comma-separated names of columns to add")
	flag.Parse()

	if *ipathp == "" {
		panic(fmt.Errorf("missing -si"))
	}
	if *idKeyColp == -1 {
		panic(fmt.Errorf("missing -idkey"))
	}
	if *keyColp == -1 {
		panic(fmt.Errorf("missing -key"))
	}
	if *idValNamesp == "" {
		panic(fmt.Errorf("missing -valnames"))
	}
	if *idValColsp == "" {
		panic(fmt.Errorf("missing -valcols"))
	}

	valcols, e := ParseValCols(*idValColsp)
	if e != nil {
		panic(e)
	}

	infoMap, e := GetInfoMap(*ipathp, *idKeyColp)
	if e != nil {
		panic(e)
	}

	e = AddIdCols(os.Stdin, os.Stdout, *keyColp, strings.Split(*idValNamesp, ","), valcols, infoMap)
	if e != nil { panic(e) }
}
