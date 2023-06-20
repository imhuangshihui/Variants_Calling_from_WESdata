#!/bin/bash

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

#If you want to include all variants in output, use '-format vcf4old' or use '-format vcf4 -allsample -withfreq' instead.
annovar=/mnt/hwstor9k_data1/junehuang/biosoft/annovar
in1=/mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/03.vqsr
perl ${annovar}/convert2annovar.pl \
	-format vcf4 \
	-allsample -withfreq --includeinfo \
	${in1}/final.vqsr.bedfilter.vcf.gz > final.avinput

# VCF annotation by annovar

date '+--- ANNOVAR Start %y-%m-%d %H:%M:%S' > annovar.log
perl ${annovar}/table_annovar.pl final.avinput \
	${annovar}/humandb/hg38 \
	-buildver hg38 \
	-out final \
	-protocol refGene,ensGene,esp6500siv2_all,exac03nontcga,kaviar_20150923,gnomad211_genome,dbnsfp35a,intervar_20180118,mcap,revel,dbscsnv11,clinvar_20221224,avsnp150 \
	-operation g,g,f,f,f,f,f,f,f,f,f,f,f \
	-remove \
	-nastring . \
	-polish >> annovar.log 2>&1 || exit 1
date '+--- ANNOVAR END %y-%m-%d %H:%M:%S' >> annovar.log
