#!/bin/bash

SF=1

TMP_LOCAL=$(pwd)

echo "Creating refresh data"

rm -rf ./refresh
mkdir -p ./refresh

cd ../dbgen

# Generate the refresh tbl files
./dbgen -s $SF -U 1 -vf

# Modify to csv
echo "CONVERTING TBL FILES IN CSV"
mv ./orders.tbl.u1 ./orders.tbl
mv ./lineitem.tbl.u1 ./lineitem.tbl
for i in `ls *.tbl`; do sed 's/|$//' $i > ${i/tbl/csv}; echo $i; done;

# Modify delete.1
sed 's/|//g' delete.1 > delete.csv

# Store in refresh directory
echo "STORED CSV FILES IN dss/refresh DIRECTORY"
mv *.csv ../dss/refresh
echo "REMOVED TBL FILES"
rm delete.1
rm *.tbl

cd $TMP_LOCAL
