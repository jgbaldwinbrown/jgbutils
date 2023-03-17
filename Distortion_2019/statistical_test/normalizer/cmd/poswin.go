package main

import (
	"github.com/jgbaldwinbrown/normalizer/pkg"
	"os"
	"flag"
	"fmt"
)

func main() {
	inpp := flag.String("i", "", "input .gz file")
	colp := flag.String("c", "", "column to window")
	winsizep := flag.Int("w", 1, "Size of tiled windows to generate")
	flag.Parse()
	if *inpp == "" {
		panic(fmt.Errorf("missing -i"))
	}
	if *colp == "" {
		panic(fmt.Errorf("missing -c"))
	}

	e := normalizer.RunPosWin(*inpp, os.Stdout, *colp, *winsizep)
	if e != nil { panic(e) }
}
