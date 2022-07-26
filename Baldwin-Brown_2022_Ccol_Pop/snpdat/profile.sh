go tool pprof --pdf ./minify_snpdat_out ./cpu${1}.pprof > file${1}.pdf
evince file${1}.pdf
