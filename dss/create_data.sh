#!/bin/bash

SF=1

TMP_LOCAL=$(pwd)

echo "Creating data"

mkdir -p ./data

cd ../dbgen

# Generate the tbl files
./dbgen -s $SF -vf

# Modify to csv
echo "CONVERTING TBL FILES IN CSV"
for i in `ls *.tbl`; do sed 's/|$//' $i > ${i/tbl/csv}; echo $i; done;

# Store in data directory
echo "STORED CSV FILES IN dss/data DIRECTORY"
mv *.csv ../dss/data
echo "REMOVED TBL FILES"
rm *.tbl

cd $TMP_LOCAL
