#!/bin/bash

# an example script for diamond:

#to make a database:
diamond makedb -in nr.faa -d nr

#to blast:
diamond blastx -d nr -q reads.fna -o matches.m8
