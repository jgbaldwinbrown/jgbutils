package normalizer

import (
	"encoding/csv"
	"fmt"
	"flag"
	"os"
	"io"
	"strconv"
)

type ExpSexId struct {
	PlateId string
	Let string
	Num int
}

type ExpSexEntry struct {
	Exp string
	Sex string
	Indiv string
}

type ExpSexSet struct {
	M map[ExpSexId]ExpSexEntry
}

func ParseExpSexLine(line []string) (ExpSexId, ExpSexEntry, error) {
	h := handle("ParseExpSexLine: %w")

	if len(line) < 6 {
		return ExpSexId{}, ExpSexEntry{}, h(fmt.Errorf("len(line) %v < 5", len(line)))
	}

	num, e := strconv.Atoi(line[2])
	if e != nil {
		return ExpSexId{}, ExpSexEntry{}, h(e)
	}

	return ExpSexId{line[0], line[1], num}, ExpSexEntry{line[3], line[4], line[5]}, nil
}

func GetExperimentSexInfo(path string) (*ExpSexSet, error) {
	h := handle("GetExperimentSexInfo: %w")

	s := &ExpSexSet{M: map[ExpSexId]ExpSexEntry{}}

	r, e := os.Open(path)
	if e != nil { return s, h(e) }
	defer r.Close()

	cr := OpenCsv(r)

	for l, e := cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { return s, h(e) }

		id, entry, e := ParseExpSexLine(l)
		if e != nil { return s, h(e) }
		s.M[id] = entry
	}
	return s, nil
}

func (s *ExpSexSet) GetExpSex(line []string) (exp, sex, indiv string, err error) {
	h := handle("GetExpSex: %w")

	if len(line) < 19 {
		return "", "", "", h(fmt.Errorf("len(line) %v < 14", len(line)))
	}

	num, e := strconv.Atoi(line[18])
	if e != nil { return "", "", "", h(e) }

	es, ok := s.M[ExpSexId{line[16], line[17], num}]
	if !ok {
		return line[8], line[9], line[11], nil
	}
	return es.Exp, es.Sex, es.Indiv, nil
}

func TrueIdentity(r io.Reader, w io.Writer, experimentSexInfoPath string) error {
	h := handle("RunTrueIdentity: %w")

	// expSexInfo, e := GetExperimentSexInfo(experimentSexInfoPath)
	// if e != nil { return h(e) }

	cr := OpenCsv(r)

	cw := csv.NewWriter(w)
	defer cw.Flush()
	cw.Comma = rune('\t')

	l, e := cr.Read()
	if e != nil { return h(e) }
	e = cw.Write([]string {
		"probeset_id",
		"Chromosome",
		"Position",
		"Offset",
		"Big_Offset",
		"value",
		"let",
		"num",
		"experiment",
		"sex",
		"tissue",
		"indivs",
		"unique_id",
		"plate_id",
		"name_prefix",
		"spoofed_tissue",
	})
	if e != nil { return h(e) }

	outbuf := []string{}
	for l, e = cr.Read(); e != io.EOF; l, e = cr.Read() {
		if e != nil { return h(e) }

		// exp, sex, indiv, e := expSexInfo.GetExpSex(l)
		outbuf = append(outbuf[:0],
			l[0],
			l[1],
			l[2],
			l[3],
			l[4],
			l[5],
			l[17],
			l[18],
			l[8],
			l[9],
			l[10],
			l[11],
			l[12],
			l[16],
			l[21],
			l[20],
		)
		e = cw.Write(outbuf)
		if e != nil { return h(e) }
	}

	return nil
}

// 			l[0],
// 			l[1],
// 			l[2],
// 			l[3],
// 			l[4],
// 			l[5],
// 			l[17],
// 			l[18],
// 			exp,
// 			sex,
// 			indiv,
// 			l[16],
// 			l[21],
// 			l[20],

func RunTrueIdentities() {
	ipathp := flag.String("si", "", "path to sample exp sex identities, columns should be plate id num, plate letter, plate col num, exp, sex, indiv")
	flag.Parse()
	e := TrueIdentity(os.Stdin, os.Stdout, *ipathp)
	if e != nil { panic(e) }
}

// #     1	probeset_id	1
// #     2	Chromosome	2
// #     3	Position	3
// #     4	Offset	4
// #     5	Big_Offset	5
// #     6	afrac	6, RENAME
// #     7	let	
// #     8	num	
// #     9	experiment	FILLIN
// #    10	sex	FILLIN
// #    11	tissue	
// #    12	indivs	FILLIN
// #    13	unique_id	13
// #    14	plate_id	
// #    15	name_prefix	
// #    16	spoofed_tissue	
// #    17	true_plate	14
// #    18	true_letter	7
// #    19	true_number	8
// #    20	true_tissue	11
// #    21	spoofed_tissue_2	16
// #    22	true_name_prefix	15
