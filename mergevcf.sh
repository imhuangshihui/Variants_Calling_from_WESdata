#!/bin/bash

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate
conda activate wgs

inp=/mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/01.genomicsdb

picard MergeVcfs \
	I=${inp}/chr1.genotype.vcf \
	I=${inp}/chr2.genotype.vcf \
	I=${inp}/chr3.genotype.vcf \
	I=${inp}/chr4.genotype.vcf \
	I=${inp}/chr5.genotype.vcf \
	I=${inp}/chr6.genotype.vcf \
	I=${inp}/chr7.genotype.vcf \
	I=${inp}/chr8.genotype.vcf \
	I=${inp}/chr9.genotype.vcf \
	I=${inp}/chr10.genotype.vcf \
	I=${inp}/chr11.genotype.vcf \
	I=${inp}/chr12.genotype.vcf \
	I=${inp}/chr13.genotype.vcf \
	I=${inp}/chr14.genotype.vcf \
	I=${inp}/chr15.genotype.vcf \
	I=${inp}/chr16.genotype.vcf \
	I=${inp}/chr17.genotype.vcf \
	I=${inp}/chr18.genotype.vcf \
	I=${inp}/chr19.genotype.vcf \
	I=${inp}/chr20.genotype.vcf \
	I=${inp}/chr21.genotype.vcf \
	I=${inp}/chr22.genotype.vcf \
	I=${inp}/chrX.genotype.vcf \
	I=${inp}/chrY.genotype.vcf \
	I=${inp}/chrM.genotype.vcf \
	O=raw_vairant.vcf.gz
