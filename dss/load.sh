#!/bin/bash

DATABASE=$1
SCHEMA_FILE="../dbgen/dss.ddl"

TMP_LOCAL=$(pwd)

cd ./dss


echo ""
echo "======================================================"
echo ""
echo "CREATE DATABASE"
psql -c "DROP DATABASE $DATABASE"
psql -c "CREATE DATABASE $DATABASE"

echo ""
echo "======================================================"
echo ""
echo "CREATE TPCH TABLES, INDEXES AND CONSTRAINTS"
psql -d $DATABASE -c "\i $SCHEMA_FILE"

echo ""
echo "======================================================"
echo ""
echo "POPULATE DATABASE"
psql -d $DATABASE -c "\COPY region   FROM './data/region.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY nation   FROM './data/nation.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY customer FROM './data/customer.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY supplier FROM './data/supplier.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY part     FROM './data/part.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY partsupp FROM './data/partsupp.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY orders   FROM './data/orders.csv' WITH (FORMAT csv, DELIMITER '|')";
psql -d $DATABASE -c "\COPY lineitem FROM './data/lineitem.csv' WITH (FORMAT csv, DELIMITER '|')";

cd $TMP_LOCAL
