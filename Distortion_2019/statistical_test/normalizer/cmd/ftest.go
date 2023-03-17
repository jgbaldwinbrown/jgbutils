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
	bloodcolp := flag.String("bloodcol", "", "name of column listing control samples as \"blood\"")
	testcolp := flag.String("testcol", "", "column to use for all test")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *valcolp == "" {
		panic(fmt.Errorf("missing -v"))
	}
	if *bloodcolp == "" {
		panic(fmt.Errorf("missing -bloodcol"))
	}
	if *testcolp == "" {
		panic(fmt.Errorf("missing -testcol"))
	}

	e := normalizer.RunFullFTest(*inpp, os.Stdout, *valcolp, *bloodcolp, *testcolp)
	if e != nil { panic(e) }
}
