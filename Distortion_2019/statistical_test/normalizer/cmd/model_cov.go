package main

import (
	"github.com/jgbaldwinbrown/normalizer/pkg"
	"os"
	"flag"
	"fmt"
)

func main() {
	inpp := flag.String("i", "", "input .gz file")
	valcolp := flag.String("v", "", "value column name")
	indepcolp := flag.String("indep", "", "independent predictor column name")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *valcolp == "" {
		panic(fmt.Errorf("missing -v"))
	}
	if *indepcolp == "" {
		panic(fmt.Errorf("missing -indep"))
	}

	e := normalizer.RunLinearModelCoverage(*inpp, os.Stdout, *valcolp, *indepcolp)
	if e != nil { panic(e) }
}
