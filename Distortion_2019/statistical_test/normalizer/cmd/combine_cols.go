package main

import (
	"strings"
	"github.com/jgbaldwinbrown/normalizer/pkg"
	"os"
	"flag"
	"fmt"
)

func main() {
	inpp := flag.String("i", "", "input .gz file")
	colsp := flag.String("c", "", "comma-separated columns to combine")
	sepp := flag.String("s", "_", "string to use to separate column values / names")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *colsp == "" {
		panic(fmt.Errorf("missing -c"))
	}
	if *sepp == "" {
		panic(fmt.Errorf("missing -s"))
	}

	cols := strings.Split(*colsp, ",")

	e := normalizer.RunColCombine(*inpp, os.Stdout, cols, *sepp)
	if e != nil { panic(e) }
}
