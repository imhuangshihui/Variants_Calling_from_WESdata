#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#
source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate
conda activate wgs

date '+--- fastp01 start %y-%m-%d %H:%M:%S' > HCM0001.fastp.log
fastp -i HCM0010_DKDN220015872-1A_HCK55DSX5_L2_1.fq.gz -I HCM0010_DKDN220015872-1A_HCK55DSX5_L2_2.fq.gz \
        -o HCM0010_DKDN220015872-1A_HCK55DSX5_L2_1.filter.fq.gz -O HCM0010_DKDN220015872-1A_HCK55DSX5_L2_2.filter.fq.gz 1>> HCM0001.fastp.log 2 >&1 || exit 1

date '+--- fastp01 end %y-%m-%d %H:%M:%S' >> HCM0001.fastp.log
