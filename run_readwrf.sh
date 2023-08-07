#!/bin/bash
Lpath="./netcdf/lib"
Ipath="./netcdf/include"
gfortran read_wrf.f90 -L${Lpath} -lnetcdff -lnetcdf -I${Ipath} -o read_wrf.exe
./read_wrf.exe