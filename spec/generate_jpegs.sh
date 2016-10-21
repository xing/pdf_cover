#!/bin/bash

# NOTE: Update the converter.rb file when changing these values
DEFAULT_FORMAT="jpeg"
DEFAULT_QUALITY=85
DEFAULT_RESOLUTION=300
DEFAULT_ANTIALIASING=4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/test_pdfs"

echo "Working directory $DIR"

echo "Removing previous output"
rm $DIR/*.jpg

IFS="
"

for INPUT_FILE in $(cd $DIR && ls *.pdf)
do
  OUTPUT_FILE="$DIR/${INPUT_FILE/.pdf/.jpg}"
  echo "Generating $OUTPUT_FILE from $INPUT_FILE"
  gs -sOutputFile="$OUTPUT_FILE" \
    -dNOPAUSE \
    -sDEVICE="$DEFAULT_FORMAT" \
    -dJPEGQ=$DEFAULT_QUALITY \
    -dFirstPage=1 \
    -dLastPage=1 \
    -r$DEFAULT_RESOLUTION \
    -dTextAlphaBits=$DEFAULT_ANTIALIASING \
    -dGraphicsAlphaBits=$DEFAULT_ANTIALIASING \
    -q "$DIR/$INPUT_FILE" -c quit
done
