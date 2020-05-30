#!/bin/bash
set -e

python3 sync2baypass.py <(gunzip -c ../full_run/inter/full_sync_all_backup.sync.gz | head -n 10000000 | tail -n 100000)
