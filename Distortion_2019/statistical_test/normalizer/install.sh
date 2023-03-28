#!/bin/bash
set -e

cd cmd && (
	ls *.go | while read i ; do
		go build $i
		a=`echo $i | sed 's/\.go//'`
		cp $a ~/mybin/
	done
)
