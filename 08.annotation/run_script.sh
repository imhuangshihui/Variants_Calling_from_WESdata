#!/bin/bash

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate


cd ./GT_raw

for i in {3..61}
do
	python3 ../add_patientID.py pwh${i}
done

