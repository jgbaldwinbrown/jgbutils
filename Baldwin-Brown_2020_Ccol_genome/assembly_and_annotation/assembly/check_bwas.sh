#!/bin/bash
find temp/bwa* -type f | grep -E '\/data\/' | xargs du -shc
find temp/bwa* -type f | grep -E '\/data\/' | xargs ls -l

