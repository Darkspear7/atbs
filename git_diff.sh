#!/bin/bash

if [ ! -d "diff_files" ]; then
	mkdir "diff_files"
fi

DIFF_PATH="diff_files/$(date +%Y%m%d%H%M).diff"

OPTION=$1
 
git diff $OPTION > $DIFF_PATH

echo "File created : $DIFF_PATH"

subl $DIFF_PATH &
