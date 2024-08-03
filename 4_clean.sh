#!/bin/sh

cd ./dbgen
make clean
cd ..

rm -f ./dss/data/*
rm -f ./dss/queries/*
rm -f ./dss/refresh/*

touch ./dss/data/.gitkeep
touch ./dss/queries/.gitkeep
touch ./dss/refresh/.gitkeep

echo "Limpo"