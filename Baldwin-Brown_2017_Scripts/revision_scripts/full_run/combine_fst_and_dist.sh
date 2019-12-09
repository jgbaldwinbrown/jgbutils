#!/bin/bash
set -e

paste \
    <(cat inter/pair_fst_hap2_edited.txt | sed 's/"//g' | tr ' ' '\t' | sort -t '	' -k6,7) \
    <(cat data/fst_fulldat2.txt | sed 's/"//g' | sort -t '	' -k6,7) \
> inter/fst_dist_combo_hap2.txt

paste \
    <(cat inter/pair_fst_hap2_edited2a.txt | sed 's/"//g' | tr ' ' '\t' | sort -t '	' -k6,7) \
    <(cat data/fst_fulldat2a.txt | sed 's/"//g' | sort -t '	' -k6,7) \
> inter/fst_dist_combo_hap2_2a.txt

#inter/pair_fst_hap2_edited.txt
#data/fst_fulldat2a.txt


#"2" "Pool1" "Pool2" 0.131810487163936 1314641 "Cassidy" "WAL"
#"3" "Pool1" "Pool3" 0.0586962516226127 1314641 "Cassidy" "Hayden"
#"4" "Pool1" "Pool4" 0.229941499309647 1314641 "Cassidy" "JT4"
#"5" "Pool1" "Pool5" 0.236691824173914 1314641 "Cassidy" "Forsling"
#"6" "Pool1" "Pool6" 0.271387694908527 1314641 "Cassidy" "Ares"
#"7" "Pool1" "Pool7" 0.288187715736725 1314641 "Cassidy" "LTER"
#"8" "Pool1" "Pool8" 0.136135342752444 1314641 "Cassidy" "AMT1"
#"9" "Pool1" "Pool9" 0.194833142840944 1314641 "Cassidy" "SWP4"
#"10" "Pool1" "Pool10" 0.242075784933522 1314641 "Cassidy" "JD1"
#"11" "Pool1" "Pool11" 0.269053308650411 1314641 "Cassidy" "Tank011"


#fst	amt1	jd1	0.0507287008176	distance	AMT1	JD1	7659.83787223
#fst	amt1	swp4	0.0464031924059	distance	AMT1	SWP4	8742.35844527
#fst	amt1	tank011	0.0549753916518	distance	AMT1	Tank 011	23125.1332422
#fst	ares	amt1	0.0552665081907	distance	Ares	AMT1	6787.8638738
#fst	ares	jd1	0.0231097085905	distance	Ares	JD1	796.899470699
#fst	ares	lter	0.024118762821	distance	Ares	LTER	42463.146897
#fst	ares	swp4	0.0173528858195	distance	Ares	SWP4	1894.99692861
#fst	ares	tank011	0.0216763383925	distance	Ares	Tank 011	14896.3836988
#fst	cassidy	amt1	0.0232260708946	distance	Cassidy	AMT1	19091.4975085
#fst	cassidy	ares	0.046009246735	distance	Cassidy	Ares	12106.6042231
