package main

import (
	"github.com/jgbaldwinbrown/normalizer/pkg"
	"os"
	"flag"
	"fmt"
)

func main() {
	inpp := flag.String("i", "", "input .gz file")
	hitscolp := flag.String("h", "", "name of column containing hits")
	countcolp := flag.String("c", "_", "name of column containing total count of hits and alt hits")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *hitscolp == "" {
		panic(fmt.Errorf("missing -h"))
	}
	if *countcolp == "" {
		panic(fmt.Errorf("missing -c"))
	}

	e := normalizer.RunAddAfrac(*inpp, os.Stdout, *hitscolp, *countcolp)
	if e != nil { panic(e) }
}
