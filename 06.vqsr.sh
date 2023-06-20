#!/bin/bash
# Get the Variant Quality Score Recalibration (VQSR) file before using Annovar to annotate it

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

db=/mnt/hwstor9k_data1/junehuang/db/GATK_hg38

#Recalibrating SNPs in exome data
date '+--- VQSR Start %y-%m-%d %H:%M:%S' 
/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk VariantRecalibrator \
  -R ${db}/Homo_sapiens_assembly38.fasta \
  -V /mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/02.combinevcf/raw_vairant.vcf.gz \
  -resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${db}/hapmap_3.3.hg38.vcf.gz \
  -resource:omni,known=false,training=true,truth=false,prior=12.0 ${db}/1000G_omni2.5.hg38.vcf.gz \
  -resource:1000G,known=false,training=true,truth=false,prior=10.0 ${db}/1000G_phase1.snps.high_confidence.hg38.vcf.gz \
  -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${db}/Homo_sapiens_assembly38.dbsnp138.vcf \
  -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
  -mode SNP \
  -O output.recal \
  --tranches-file output.tranches 
#  --rscript-file output.plots.R 1>> VQSR_hcm.log 2>&1 || exit 1
date '+--- VQSR End %y-%m-%d %H:%M:%S'
#Applying recalibration/filtering to SNPs
date '+--- Apply VQSR Start %y-%m-%d %H:%M:%S' 
/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk ApplyVQSR \
  -R ${db}/Homo_sapiens_assembly38.fasta \
  -V /mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/02.combinevcf/raw_vairant.vcf.gz \
  -O final.vqsr.vcf.gz \
  --truth-sensitivity-filter-level 99.0 \
  --tranches-file output.tranches \
  --recal-file output.recal \
  -mode SNP
date '+--- Apply VQSR End %y-%m-%d %H:%M:%S' 
