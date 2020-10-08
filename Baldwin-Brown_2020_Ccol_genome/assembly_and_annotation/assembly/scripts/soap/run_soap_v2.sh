#!/bin/bash

mkdir -p temp/soap/unfiltered

SOAPdenovo-63mer all -s scripts/soap/annarun_config_2.txt -K 63 -R -o temp/soap/unfiltered/shrimp_soap_assembly_v2 1>temp/soap/unfiltered/soap2_log.txt 2> temp/soap/unfiltered/soap2_err.txt


