#!/bin/bash
# Only choose the regions that hit the bed file. You can skip this step if you want to keep all the regions.

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

#Generate vcf.gz file
tabix -p vcf final.vqsr.vcf.gz
tabix -f final.vqsr.vcf.gz -R S07604514_Regions.bed > final.vqsr.bedfilter.vcf.gz 
