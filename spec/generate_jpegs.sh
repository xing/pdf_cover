#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/test_pdfs"

echo "Removing previous output"
rm $DIR/*.jpg

IFS="
"

for INPUT_FILE in $(cd $DIR && ls *.pdf)
do
  OUTPUT_FILE="$DIR/${INPUT_FILE/.pdf/.jpg}"
  echo "Generating $OUTPUT_FILE from $INPUT_FILE"
  gs -sOutputFile="$OUTPUT_FILE" -dNOPAUSE -sDEVICE="jpeg" -dJPEGQ=95 -dFirstPage=1 -dLastPage=1 -r300 -q "$DIR/$INPUT_FILE" -c quit
done
