#!/bin/bash
set -e

cat "$@" | \
awkf '
{
    printf("%s\t%s\t%s", $1, $2-1, $2)
    for (i=3; i<=NF; i++) {
        printf("\t%s", $i);
    }
    printf("\n");
}
'
