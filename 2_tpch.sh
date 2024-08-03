#!/bin/sh

LAST_RUN=$(ls -d "./results"/*/ 2>/dev/null | sed -r 's#.*/([0-9]+)/#\1#' | sort -rnu | head -1)
if [ -z "$LAST_RUN" ]; then
  RUN_NUM=1
else
  RUN_NUM=$(echo "$LAST_RUN + 1" | bc)
fi

RESULTS=results/$RUN_NUM
DBNAME=tpch

echo "Salvando em $RESULTS"
mkdir -p $RESULTS


echo "2_tpch: storing settings"
psql postgres -c "select name,setting from pg_settings" > $RESULTS/settings.log

echo "2_tpch: loading data"
./dss/load.sh $DBNAME

mkdir -p results/results

echo "2_tpch: running TPC-H benchmark"

# QI TEST
rm -f ./$RESULTS/time.tmp
rm -f ./$RESULTS/time_PowerTest.txt
for n in `seq 1 22`
do

	q="./dss/queries/$n.sql"

	if [ -f "$q" ]; then
		echo "======= running query $n ======="
		/usr/bin/time -o ./$RESULTS/time.tmp -f "%e" psql $DBNAME < $q > ./results/results/$n
		cat ./$RESULTS/time.tmp >> ./$RESULTS/time_PowerTest.txt
	fi;

done;
rm -f ./$RESULTS/time.tmp

# RI TEST
rm -f ./$RESULTS/time.tmp
# RF1 - insert
echo "======= RF1 ======="
/usr/bin/time -o ./$RESULTS/time.tmp -f "%e" psql -d $DBNAME -c "\COPY lineitem FROM './dss/refresh/lineitem.csv' WITH (FORMAT csv, DELIMITER '|')"  > /dev/null;
LineitemInsertTime=$(cat ./$RESULTS/time.tmp)
/usr/bin/time -o ./$RESULTS/time.tmp -f "%e" psql -d $DBNAME -c "\COPY orders FROM './dss/refresh/orders.csv' WITH (FORMAT csv, DELIMITER '|')"  > /dev/null;
OrdersInsertTime=$(cat ./$RESULTS/time.tmp)
total=$(echo "$LineitemInsertTime + $OrdersInsertTime" | bc -l)
total=$(printf "%.2f" $total)
echo "$total" >> ./$RESULTS/time_PowerTest.txt
rm -f ./$RESULTS/time.tmp
# RF2 - delete
echo "======= RF2 ======="
# Gera o script SQL com o caminho absoluto para deletar os valores em delete.csv
delete_csv_path=$(realpath './dss/refresh/delete.csv')
cat <<EOF > delete_script.sql
CREATE TEMP TABLE tmp_x (nr int);

\COPY tmp_x FROM '$delete_csv_path' WITH (FORMAT csv);

DELETE FROM lineitem
USING tmp_x
WHERE lineitem.l_orderkey = tmp_x.nr;

DELETE FROM orders
USING tmp_x
WHERE orders.o_orderkey = tmp_x.nr;

DROP TABLE tmp_x;
EOF
/usr/bin/time -o ./$RESULTS/time.tmp -f "%e" psql $DBNAME < ./delete_script.sql > /dev/null
rm -f ./delete_script.sql
cat ./$RESULTS/time.tmp >> ./$RESULTS/time_PowerTest.txt
rm -f ./$RESULTS/time.tmp

echo "2_tpch: finished TPC-H Power benchmark"
