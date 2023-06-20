#!/bin/bash

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

time samtools flagstat -@ 30 PWHA000037.sorted.markdup.bam > PWHA000037.sorted.markdup.bam.stat 
