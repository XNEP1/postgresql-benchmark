#!/bin/sh

cd ./dbgen
make clean
cd ..

rm -f ./dss/data/*
rm -f ./dss/queries/*
rm -f ./dss/refresh/*

echo "Limpo"