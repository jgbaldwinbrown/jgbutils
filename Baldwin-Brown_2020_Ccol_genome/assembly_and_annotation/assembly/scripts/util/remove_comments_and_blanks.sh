#!/bin/bash

cat $1 | sed 's/#.*//g' | grep -vE '^\s*$'
