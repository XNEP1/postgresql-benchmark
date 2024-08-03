#!/bin/sh

SF=1
S=1

TEST_NUM=$1
if [ -z $TEST_NUM ]; then
    LAST_RUN=$(ls -d "./results"/*/ 2>/dev/null | sed -r 's#.*/([0-9]+)/#\1#' | sort -rnu | head -1)
    TEST_NUM=$LAST_RUN
fi

RESULTS=./results/$TEST_NUM
POWERTEST_RESULT_PATH=$RESULTS/time_PowerTest.txt

if [ ! -f "$POWERTEST_RESULT_PATH" ]; then
    echo "O arquivo $POWERTEST_RESULT_PATH não existe. Execute 2_tpch.sh antes."
    exit 0
fi

echo "Calculando metricas do resultado $TEST_NUM"

TotalTime=$(awk '{sum += $1} END {printf "%.2f\n", sum}' $POWERTEST_RESULT_PATH);
echo "Total time: $TotalTime segs"
echo ""

# Geometric Mean of Power Test
GM_POWERTEST=$(awk 'BEGIN{E = exp(1);} $1>0{tot+=log($1); c++} END{m=tot/c; printf "%.2f\n", E^m}' $POWERTEST_RESULT_PATH)
echo "Power Test Geometric Mean: $GM_POWERTEST"
echo ""

POWER=$(echo "scale=2; (3600 * $SF) / $GM_POWERTEST" | bc -l)
echo "TPC-H Power@Size=$SF = $POWER"

THROUGHPUT=$(echo "scale=2; ($S*22*3600)/($TotalTime*$SF)" | bc)
echo "TPC-H Throughput@Size=$SF = $THROUGHPUT"

QPHH=$(echo "scale=2; sqrt($POWER*$THROUGHPUT)" | bc -l)
echo "TPC-H QphH@Size=$SF = $QPHH"