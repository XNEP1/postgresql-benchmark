#!/bin/bash

DBNAME=tpch

if [ ! -f "./dbgen/dbgen" ]; then
    echo "Baixe o TPC-H no site deles."
    echo "O dbgen deve estar compilado na pasta dbgen"
    echo "Etapa 1: Faça uma cópia de dbgen/makefile.suite chamado makefile"
    echo "Etapa2: Abra o arquivo dbgen/makefile e preenxa os parametros no começo do arquivo (CC,DATABASE,MACHINE,WORKLOAD)"
    exit 0
fi;

cd ./dss

./create_data.sh
./create_refresh.sh
./makequeries.sh

cd ..

