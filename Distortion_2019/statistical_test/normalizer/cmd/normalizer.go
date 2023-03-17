package main

import (
	"github.com/jgbaldwinbrown/normalizer/pkg"
	"strings"
	"os"
	"flag"
	"fmt"
)

func main() {
	inpp := flag.String("i", "", "input .gz file")
	valcolp := flag.String("v", "", "value column name")
	idcolsp := flag.String("id", "", "id column names, comma-separated")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *valcolp == "" {
		panic(fmt.Errorf("missing -v"))
	}
	if *idcolsp == "" {
		panic(fmt.Errorf("missing -id"))
	}

	idcols := strings.Split(*idcolsp, ",")
	if len(idcols) < 1 {
		panic(fmt.Errorf("could not parse -id %v", *idcolsp))
	}

	e := normalizer.Run(*inpp, os.Stdout, *valcolp, idcols)
	if e != nil { panic(e) }
}
