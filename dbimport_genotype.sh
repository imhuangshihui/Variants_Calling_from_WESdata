#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#
source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

db=/mnt/hwstor9k_data1/junehuang/db/GATK_hg38
input=/mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/01.genomicsdb

### Combine GVCF ####
for i in {1..5}
do
	date '+--- GenomicsDBimport gvcf Start  %y-%m-%d %H:%M:%S' >> genomicsdbimport.log
	/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk --java-options "-Xms5g -Xmx32g" GenomicsDBImport \
	    --genomicsdb-workspace-path ${input}/db${i} \
            --batch-size 50 \
            --sample-name-map ${input}/cohort.sample_map \
            --reader-threads 5 \
	    --intervals chr${i} 1>> genomicsdbimport.log 2>&1 || exit 1
	date '+--- GenomicsDBImport gvcf End  %y-%m-%d %H:%M:%S' >> genomicsdbimport.log
done

### Joint Genotyping ###
for i in {1..5}
do
	date '+--- Genotype gvcf  Start %y-%m-%d %H:%M:%S' > genotypevcf.log
	/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk --java-options "-Xms4g" GenotypeGVCFs \
	    -R ${db}/Homo_sapiens_assembly38.fasta \
	    -V gendb://db${i} \
	    -O ./chr${i}.genotype.vcf 1>> genotypevcf.log 2>&1 || exit 1
	date '+--- Genotype gvcf End %y-%m-%d %H:%M:%S' >> genotypevcf.log
done
