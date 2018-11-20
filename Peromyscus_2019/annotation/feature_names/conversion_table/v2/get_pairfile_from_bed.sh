#!/bin/bash

cat $1 | cut -d '	' -f 10,15 | cut -d ' ' -f 4 | tr -d '"' | tr -d ';'

