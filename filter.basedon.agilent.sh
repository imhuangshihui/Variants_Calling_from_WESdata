#!/bin/bash

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

#Generate vcf.gz file
tabix -p vcf final.vqsr.vcf.gz
tabix -f final.vqsr.vcf.gz -R S07604514_Regions.bed > final.vqsr.bedfilter.vcf.gz 
