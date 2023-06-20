#!/bin/bash

bash annovar.sh

cat hcm1to16.annovar0110.hg38_multianno.txt | head -1 | tr '\t' '\n' | cat -n > annovar.col.name
#annovar.col.name
# 1:Chr:...1
# The raw row order:The col name from annovar output:The column order (almost) same as Wenjuan's spreadsheet

# 1.Filter step by step
cat hcm1to16.annovar0110.hg38_multianno.txt | awk '{if($6!~"^ncRNA"){print $0}}' | awk '{if($6~"exonic" || ($6~"splicing")) {print $0}}' | awk '{if($11!~"^ncRNA"){print $0}}' | awk '{if($11~"exonic" || ($11~"splicing")) {print $0}}' | awk -F '\t' '{if($9!~"^unknown"){print}}' | awk -F '\t' '$9!="synonymous SNV"{print}' | awk -F '\t' '{if($14!~"^unknown"){print}}' | awk -F '\t' '$14!="synonymous SNV"{print}' | awk -F '\t' '{if($16<=0.01){print}}' | awk -F '\t' '{if($25<=0.01){print}}' | awk -F '\t' '{if($28<0.01){print}}' | awk -F '\t' '{if($36<0.01){print}}' | awk -F '\t' '{if(($100>2) || ($100<0)){print}}' | awk -F '\t' 'BEGIN {OFS = "\t"} {print $1,$2,$4,$5,$153,$28,$36,$86,$100,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$47,$50,$56,$59,$62,$65,$68,$73,$79,$148,$149,$150,$151,$152}' > step23456.filter.file

###### Add sample identifier(PWHxxxx) and diagnosis(ApHCM, HCM, etc.) column ######
# 2.Creat the variant position file and use it as feed to raw vcf file to find the variant's genotype
cat step23456.filter.file | cut -f2 > variant.pos.txt

# 3.Formatted the raw vcf file to the one we want which only keeps 【chr	pos	sample's genotype(0|1, 1|2)】
## 3.1 
zcat hcm.snps.VQSR.vcf.gz | grep -v '^##' | cut -f1-2,10-25 | sed 's+/+|+g' > hcm.snps.VQSR.noheader.vcf
## 3.2 Creat the new documentary to store the genotype for each sample and combine all the sample GT into one file
# Or use variant.pos.py to filter the useful variant first, so it won't search the whole vcf file
sh genotype.extract.sh
cat hcm.snps.VQSR.noheader.vcf | cut -f1-2 > chr.pos.col
paste chr.pos.col ./GT/genotype.col > hcm1to16.snps.VQSR.onlyGT.vcf

# 4.Get the sample name without same genotype like '0|0', '1|1' ... '6|6'  【chr	pos	sample_name】
# Better check it first to see how many kinds of gt we don't need
python3 sample.name.py  
python3 add_sampleID.py
python3 add_diagnosis.py


