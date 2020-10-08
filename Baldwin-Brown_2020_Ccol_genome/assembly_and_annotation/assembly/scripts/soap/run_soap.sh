#!/bin/bash

mkdir -p temp/soap/annarun1

SOAPdenovo-63mer -s scripts/soap/annarun_config_1.txt -K 63 -R -o shrimp_soap_assembly_v1 1>soap1_log.txt 2> soap1_err.txt


