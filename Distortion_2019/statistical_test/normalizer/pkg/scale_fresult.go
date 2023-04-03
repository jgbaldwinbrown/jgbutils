package normalizer

import (
	"compress/gzip"
	"os"
	"flag"
	"strings"
	"bufio"
	"io"
	"fmt"
	"strconv"
)

type Model struct {
	Name string
	Coeffs []float64
}

func ParseCoeffs(fields []string) ([]float64, error) {
	h := handle("ParseCoeffs: %w")
	var coeffs []float64

	for _, field := range fields {
		c, e := strconv.ParseFloat(field, 64)
		if e != nil { return nil, h(e) }
		coeffs = append(coeffs, c)
	}
	return coeffs, nil
}

func ParseModel(line []string) (Model, error) {
	h := handle("ParseModel: %w")
	if len(line) < 1 {
		return Model{}, h(fmt.Errorf("len(line) < 1"))
	}

	coeffs, e := ParseCoeffs(line[1:])
	if e != nil { return Model{}, h(e) }

	return Model{line[0], coeffs}, nil
}

func ReadModel(r io.Reader) ([]Model, error) {
	h := handle("ReadModel: %w")
	cr := OpenCsv(r)
	models := []Model{}

	for line, e := cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return nil, h(e) }

		m, e := ParseModel(line)
		if e != nil { return nil, h(e) }
		models = append(models, m)
	}
	return models, nil
}

func ReadModelPath(path string) ([]Model, error) {
	h := handle("ReadModelPath: %w")

	r, e := os.Open(path)
	if e != nil { return nil, h(e) }
	defer r.Close()

	gr, e := gzip.NewReader(r)
	if e != nil { return nil, h(e) }
	defer gr.Close()

	return ReadModel(gr)
}

func MapProbeToCoeffs(models []Model) map[string][]float64 {
	m := map[string][]float64{}
	for _, model := range models {
		m[model.Name] = model.Coeffs
	}
	return m
}

type ChrPos struct {
	Chr string
	Pos string
}

type ProbeChrPos struct {
	Probe string
	ChrPos
}

func ReadProbeChrPos(path string) ([]ProbeChrPos, error) {
	h := handle("ReadProbeInfo: %w")

	cr, gr, fp, e := Open(path)
	defer fp.Close()
	defer gr.Close()
	cr.Comma = rune(',')
	cr.LazyQuotes = false

	pcps := []ProbeChrPos{}

	line, e := cr.Read()
	if e != nil { return nil, h(e) }

	for line, e = cr.Read(); e != io.EOF; line, e = cr.Read() {
		if e != nil { return nil, h(e) }

		if len(line) < 5 {
			return nil, h(fmt.Errorf("len(line) %v < 6", len(line)))
		}

		pcps = append(pcps, ProbeChrPos{line[0], ChrPos{line[4], line[5]}})
	}
	return pcps, nil
}

func MapChrPosToProbe(pcps []ProbeChrPos) map[ChrPos]string {
	m := map[ChrPos]string{}
	for _, pcp := range pcps {
		m[pcp.ChrPos] = pcp.Probe
	}
	return m
}

func Truncate(val int, step int) int {
	return (val / step) * step
}

func MapChrPosWinToProbe(pcps []ProbeChrPos, winsize int) map[ChrPos][]string {
	m := map[ChrPos][]string{}
	for _, pcp := range pcps {
		pos, e := strconv.ParseInt(pcp.Pos, 0, 64)
		if e != nil { panic(e) }
		chrpos := ChrPos{pcp.Chr, fmt.Sprint(Truncate(int(pos), winsize))}
		m[chrpos] = append(m[chrpos], pcp.Probe)
	}
	return m
}

func MapChrToProbes(pcps []ProbeChrPos) map[string][]string {
	m := map[string][]string{}
	for _, pcp := range pcps {
		m[pcp.Chr] = append(m[pcp.Chr], pcp.Probe)
	}
	return m
}

type FTestResult struct {
	Name1 string
	Name2 string
	Count1 float64
	Count2 float64
	Mean1 float64
	Mean2 float64
	Sd1 float64
	Sd2 float64
	F float64
	Df1 float64
	Df2 float64
	P float64
}

func ParseFTestResult(line string) (FTestResult, error) {
	r := FTestResult{}
	_, e := fmt.Sscanf(line, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\n",
		&r.Name1, &r.Name2,
		&r.Count1, &r.Count2,
		&r.Mean1, &r.Mean2,
		&r.Sd1, &r.Sd2,
		&r.F,
		&r.Df1, &r.Df2,
		&r.P,
	)
	return r, e
}

func ReadFTestResults(r io.Reader) ([]FTestResult, error) {
	h := handle("ReadFTestResults: %w")
	results := []FTestResult{}
	s := bufio.NewScanner(r)
	s.Buffer([]byte{}, 1e12)

	for s.Scan() {
		result, e := ParseFTestResult(s.Text())
		if e != nil { return nil, h(e) }
		results = append(results, result)
	}
	return results, nil
}

type ScaledFTest struct {
	Name1 string
	Name2 string
	ScaledSdDiff float64
}

func MeanSlope(probes []string, probeToCoeffMap map[string][]float64) (float64, error) {
	if len(probes) < 1 {
		return 0, fmt.Errorf("MeanSlope: No probes")
	}

	sum := 0.0
	count := 0.0
	for _, probe := range probes {
		coeffs, ok := probeToCoeffMap[probe]
		if !ok {
			// return 0, fmt.Errorf("MeanSlope: probe %v not in map", probe)
			continue
		}
		slope := coeffs[1]
		sum += slope
		count++
	}

	return sum / count, nil
}

func ScaleSdDiff(ftest FTestResult, slope float64) float64 {
	diff := ftest.Sd2 - ftest.Sd1
	scaleFactor := -slope / 2.0
	return diff * scaleFactor
}

func ScaleMeanDiff(ftest FTestResult, slope float64) float64 {
	diff := ftest.Mean2 - ftest.Mean1
	return diff * slope
}

func ScaleFTestPerChrom(ftest FTestResult, chrToProbeMap map[string][]string, probeToCoeffMap map[string][]float64) (ScaledFTest, error) {
	h := handle("ScaleFTestPerChrom: %w")

	namefields := strings.Split(ftest.Name2, "_")
	if len(namefields) < 2 {
		return ScaledFTest{}, h(fmt.Errorf("len(namefields) < 2"))
	}
	chr := namefields[1]

	probes, ok := chrToProbeMap[chr]
	if !ok {
		return ScaledFTest{}, h(fmt.Errorf("chr %v not in map", chr))
	}

	meanSlope, e := MeanSlope(probes, probeToCoeffMap)
	if e != nil { return ScaledFTest{}, h(e) }

	return ScaledFTest {
		ftest.Name1,
		ftest.Name2,
		ScaleSdDiff(ftest, meanSlope),
	}, nil
}

func ScaleFTestsPerChrom(ftests []FTestResult, chrToProbeMap map[string][]string, probeToCoeffMap map[string][]float64) ([]ScaledFTest, error) {
	h := handle("ScaleFTestsPerChrom: %w")
	scaled := []ScaledFTest{}

	for _, ftest := range ftests {
		scaledone, e := ScaleFTestPerChrom(ftest, chrToProbeMap, probeToCoeffMap)
		if e != nil { return nil, h(e) }
		scaled = append(scaled, scaledone)
	}

	return scaled, nil
}

func ScaleFTestPerChrPos(ftest FTestResult, chrPosToProbeMap map[ChrPos][]string, probeToCoeffMap map[string][]float64) (ScaledFTest, error) {
	h := handle("ScaleFTestPerChrom: %w")

	namefields := strings.Split(ftest.Name2, "_")
	if len(namefields) < 3 {
		return ScaledFTest{}, h(fmt.Errorf("len(namefields) < 2"))
	}
	chrPos := ChrPos{namefields[1], namefields[2]}

	probes, ok := chrPosToProbeMap[chrPos]
	if !ok {
		return ScaledFTest{}, h(fmt.Errorf("chrPos %v not in map", chrPos))
	}

	meanSlope, e := MeanSlope(probes, probeToCoeffMap)
	if e != nil { return ScaledFTest{}, h(e) }

	return ScaledFTest {
		ftest.Name1,
		ftest.Name2,
		ScaleSdDiff(ftest, meanSlope),
	}, nil
}

func ScaleFTestsPerChrPos(ftests []FTestResult, chrPosToProbeMap map[ChrPos][]string, probeToCoeffMap map[string][]float64) ([]ScaledFTest, error) {
	h := handle("ScaleFTestsPerChrom: %w")
	scaled := []ScaledFTest{}

	for _, ftest := range ftests {
		scaledone, e := ScaleFTestPerChrPos(ftest, chrPosToProbeMap, probeToCoeffMap)
		if e != nil { return nil, h(e) }
		scaled = append(scaled, scaledone)
	}

	return scaled, nil
}

func WriteScaled(w io.Writer, scaled []ScaledFTest) error {
	for _, s := range scaled {
		_, e := fmt.Fprintf(w, "%v\t%v\t%v\n", s.Name1, s.Name2, s.ScaledSdDiff)
		if e != nil { return fmt.Errorf("WriteScaled: %w") }
	}
	return nil
}

func WriteScaled2(w io.Writer, ftests []FTestResult, scaled []ScaledFTest) error {
	h := handle("WriteScaled2: %w")
	if len(ftests) != len(scaled) {
		return h(fmt.Errorf("len(ftests) %v != len(scaled) %v", len(ftests), len(scaled)));
	}
	for i, s := range scaled {
		r := ftests[i]
		if r.Name1 != s.Name1 {
			return h(fmt.Errorf("r.Name1 %v != s.Name1 %v", r.Name1, s.Name1))
		}
		if r.Name2 != s.Name2 {
			return h(fmt.Errorf("r.Name2 %v != s.Name2 %v", r.Name2, s.Name2))
		}
		_, e := fmt.Fprintf(w, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\n",
			r.Name1, r.Name2,
			r.Count1, r.Count2,
			r.Mean1, r.Mean2,
			r.Sd1, r.Sd2,
			r.F,
			r.Df1, r.Df2,
			r.P,
			s.ScaledSdDiff,
		)
		if e != nil { return h(e) }
	}
	return nil
}

func GetName2(winsize int) string {
	name2 := "indiv_chrom_tissue"
	if winsize != -1 {
		name2 = "indiv_chrom_tissue_poswin"
	}
	return name2
}

func GetStat(ttest bool) string {
	stat := "f"
	if ttest {
		stat = "t"
	}
	return stat
}

func GetDiff(ttest bool) string {
	diff := "scaled_sd_diff"
	if ttest {
		diff = "scaled_mean_diff"
	}
	return diff
}

func PrintHead(w io.Writer, ttest bool, outfmt string, winsize int) error {
	if outfmt == "2" {
		return PrintHeadOf2(w, ttest, winsize)
	}
	return PrintHeadOf1(w, ttest, winsize)
}

func PrintHeadOf1(w io.Writer, ttest bool, winsize int) error {
	name2 := GetName2(winsize)
	diff := GetDiff(ttest)

	_, e := fmt.Fprintf(w, "%v\t%v\t%v",
		"control_tissue", name2,
		diff,
	)
	return e
}

func PrintHeadOf2(w io.Writer, ttest bool, winsize int) error {
	name2 := GetName2(winsize)
	stat := GetStat(ttest)
	diff := GetDiff(ttest)

	_, e := fmt.Fprintf(w, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v",
		"control_tissue", name2,
		"count1", "count2",
		"mean1", "mean2",
		"sd1", "sd2",
		stat,
		"df1", "df2",
		"p",
		diff,
	)
	return e
}


func RunScaleFTests() {
	pheadp := flag.Bool("ph", false, "Print header for output format")
	probepp := flag.String("p", "", "probe info path")
	modelpp := flag.String("m", "", "probe model path")
	winsizep := flag.Int("w", -1, "window size if using chrpos")
	ttestp := flag.Bool("t", false, "Do per-chromosome t-test instead of f-test")
	ofp := flag.String("of", "", "output format (currently supporting 1 or 2, default 1)")
	flag.Parse()

	if *pheadp {
		PrintHead(os.Stdout, *ttestp, *ofp, *winsizep)
		return
	}

	if *probepp == "" && !*ttestp {
		panic(fmt.Errorf("missing -p"))
	}
	if *modelpp == "" {
		panic(fmt.Errorf("missing -m"))
	}

	ftests, e := ReadFTestResults(os.Stdin)
	if e != nil { panic(e) }

	models, e := ReadModelPath(*modelpp)
	if e != nil { panic(e) }

	var scaled []ScaledFTest

	if *ttestp {
		if len(models) != 1 {
			panic(fmt.Errorf("len(models) %v != 1)", len(models)))
		}
		scaled, e = ScaleTTestsPerChrom(ftests, models[0].Coeffs[1])
		if e != nil { panic(e) }
	} else if *winsizep == -1 {
		probeset, e := ReadProbeChrPos(*probepp)
		if e != nil { panic(e) }

		chrtoprobe := MapChrToProbes(probeset)
		scaled, e = ScaleFTestsPerChrom(ftests, chrtoprobe, MapProbeToCoeffs(models))
		if e != nil { panic(e) }
	} else {
		probeset, e := ReadProbeChrPos(*probepp)
		if e != nil { panic(e) }

		chrpostoprobe := MapChrPosWinToProbe(probeset, *winsizep)
		scaled, e = ScaleFTestsPerChrPos(ftests, chrpostoprobe, MapProbeToCoeffs(models))
		if e != nil { panic(e) }
	}

	stdout := bufio.NewWriter(os.Stdout)
	defer stdout.Flush()

	if *ofp == "2" {
		e = WriteScaled2(stdout, ftests, scaled)
	} else {
		e = WriteScaled(stdout, scaled)
	}
	if e != nil { panic(e) }
}

func ScaleTTestPerChrom(ftest FTestResult, slope float64) (ScaledFTest, error) {
	return ScaledFTest {
		ftest.Name1,
		ftest.Name2,
		ScaleMeanDiff(ftest, slope),
	}, nil
}

func ScaleTTestsPerChrom(ftests []FTestResult, slope float64) ([]ScaledFTest, error) {
	h := handle("ScaleFTestsPerChrom: %w")
	scaled := []ScaledFTest{}

	for _, ftest := range ftests {
		scaledone, e := ScaleTTestPerChrom(ftest, slope)
		if e != nil { return nil, h(e) }
		scaled = append(scaled, scaledone)
	}

	return scaled, nil
}

