#!/bin/bash
set -e

ls *v2.png | \
lfmt > pngset.tex
latexmk --pdf pngset.tex
