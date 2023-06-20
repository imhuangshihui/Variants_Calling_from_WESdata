#!/bin/bash

mkdir GT_raw
	
for i in {3..61}
do
	cat raw.pos.gt.vcf | cut -f1-2,$i | cut -d ':' -f1 > ./GT_raw/pwh${i}
done

cd GT_raw

mv pwh3 pwh03
mv pwh4 pwh04
mv pwh5 pwh05
mv pwh6 pwh06
mv pwh7 pwh07
mv pwh8 pwh08
mv pwh9 pwh09

#paste $(ls -1 | sort) > genotype.col

# If use the variant.pos.py, then change the file 'hcm.snps.VQSR.noheader.vcf' to 'hcm1to16.snps.VQSR.filterstep23456.vcf'
