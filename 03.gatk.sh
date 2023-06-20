#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
# Create gvcf file from bam file for each sample 

source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

db=/mnt/hwstor9k_data1/junehuang/db/GATK_hg38

#### Mark Duplicate ####
date '+--- Mark Duplicate %y-%m-%d %H:%M:%S' > gatk.log
picard MarkDuplicates \
    INPUT=PWHA000037.sorted.bam \
    OUTPUT=PWHA000037.sorted.markdup.bam \
    METRICS_FILE=PWHA000037.markdup.metrics.txt \
    CREATE_INDEX=true \
    VALIDATION_STRINGENCY=SILENT \
    REMOVE_DUPLICATES=false \
    ASSUME_SORTED=true \
    TMP_DIR=./tmp 1>> gatk.log 2>&1 || exit 1
date '+--- Mark Duplicate END  %y-%m-%d %H:%M:%S' >> gatk.log

#### Base(Quality Score) Recalibration ####
#1.Analyze patterns of covariation in the sequence dataset 
date '+--- Base Quality Score Recalibration Start  %y-%m-%d %H:%M:%S' >> gatk.log
/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk BaseRecalibrator --java-options "-Xms5g -Xmx32g" \
    -I PWHA000037.sorted.markdup.bam \
    -R ${db}/Homo_sapiens_assembly38.fasta \
    --known-sites ${db}/Homo_sapiens_assembly38.dbsnp138.vcf \
    --known-sites ${db}/1000G_phase1.snps.high_confidence.hg38.vcf.gz \
    -O recal.PWHA000037.txt 1>> gatk.log 2>&1 || exit 1
date '+--- Base Quality Score Recalibration END  %y-%m-%d %H:%M:%S' >> gatk.log

#2.Apply the recalibration to your sequence data 
date '+--- Apply BQSR  Start %y-%m-%d %H:%M:%S' >> gatk.log
/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk ApplyBQSR --java-options "-Xms1g -Xmx5g" \
    -R ${db}/Homo_sapiens_assembly38.fasta \
    -I PWHA000037.sorted.markdup.bam \
    --bqsr-recal-file recal.PWHA000037.txt \
    -O PWHA000037.sorted.markdup.recal.bam 1>> gatk.log 2>&1 || exit 1
date '+--- Apply BQSR END %y-%m-%d %H:%M:%S' >> gatk.log

#### Variant Calling ####
date '+--- Running HaplotyperCaller  %y-%m-%d %H:%M:%S' >> gatk.log
#-ERC GVCF: Multi sample
#AS means allele specific annotation
time /mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk --java-options "-Xms5g -Xms32g" HaplotypeCaller -ERC GVCF \
    -G StandardAnnotation -G StandardHCAnnotation -G AS_StandardAnnotation \
    -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
    -R ${db}/Homo_sapiens_assembly38.fasta \
    -I PWHA000037.sorted.markdup.recal.bam \
    -O PWHA000037.sorted.markdup.recal.g.vcf.gz 1>> gatk.log 2>&1 || exit 1

