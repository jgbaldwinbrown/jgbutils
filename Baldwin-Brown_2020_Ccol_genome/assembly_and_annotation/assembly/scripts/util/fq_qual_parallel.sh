#!/bin/bash
parallel -l 10000 -j$1 -k --spreadstdin fq_qual 2>/dev/null
