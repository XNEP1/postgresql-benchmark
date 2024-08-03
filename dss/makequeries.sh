#!/bin/bash

TMP_LOCAL=$(pwd)

rm -rf ./queries
mkdir -p ./queries

cd ../dbgen

for q in `seq 1 22`
do
    DSS_QUERY=../dss/templates ./qgen $q > ../dss/queries/$q.sql
    #sed '/^select/i EXPLAIN ANALYZE' dss/queries/$q.sql > dss/queries/$q.explain.sql
    #cat dss/queries/$q.sql >> dss/queries/$q.explain.sql;
done

cd $TMP_LOCAL