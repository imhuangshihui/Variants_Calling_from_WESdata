#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#
source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs

db=/mnt/hwstor9k_data1/junehuang/db/GATK_hg38

### Map to Reference ###
date '+--- BWA MEM STATR %y-%m-%d %H:%M:%S' > bwa.log

bwa mem -t 48 -M -R \
        "@RG\tID:HCM0001_DKDN220015863-1A_HCK55DSX5_L2\tSM:PWHA000037\tLB:HCM0001_DKDN220015863-1A_HCK55DSX5_L2\tPL:Illumina" \
        ${db}/Homo_sapiens_assembly38.fasta \
        HCM0001_DKDN220015863-1A_HCK55DSX5_L2_1.filter.fq.gz \
        HCM0001_DKDN220015863-1A_HCK55DSX5_L2_2.filter.fq.gz | samtools view -bS -t ${db}/Homo_sapiens_assembly38.fasta.fai -o PWHA000037.bam 
date '+--- BWA MEM END %y-%m-%d %H:%M:%S' >> bwa.log
### Coordinate sort and index ###
samtools sort -m 3000000000 PWHA000037.bam -T ./tmp -o PWHA000037.sorted.bam 1>> bwa.log 2>&1 || exit 1
samtools index PWHA000037.sorted.bam 1>> bwa.log 2>&1 || exit 1

date '+--- BWA sort END %y-%m-%d %H:%M:%S' >> bwa.log
echo 'PWHA000037 BWA Finished %y-%m-%d %H:%M:%S' >> ./bwa_finish.result
