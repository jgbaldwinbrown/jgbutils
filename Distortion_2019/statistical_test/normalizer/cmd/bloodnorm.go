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
	tosubcolp := flag.String("s", "", "column to subtract")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *valcolp == "" {
		panic(fmt.Errorf("missing -v"))
	}
	if *tosubcolp == "" {
		panic(fmt.Errorf("missing -s"))
	}

	e := normalizer.RunColSub(*inpp, os.Stdout, *valcolp, *tosubcolp)
	if e != nil { panic(e) }
}
