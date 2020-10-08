#!/bin/bash
echo "$@" | tr ' ' '\n' | while read i
do
outname=`echo "$(basename $i .txt)_backup.txt"`
cp --backup=t $i nohup_backups/$outname && trash $i
done

