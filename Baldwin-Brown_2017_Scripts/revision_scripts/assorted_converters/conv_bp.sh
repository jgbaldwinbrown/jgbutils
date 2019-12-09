#!/bin/bash
set -e

gunzip -c ./inter/full_sync_all.sync.gz | \
python3 ../assorted_converters/sync2baypass.py \
> inter/sync2bp.txt
