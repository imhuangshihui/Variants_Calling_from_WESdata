source /mnt/hwstor9k_data1/junehuang/biosoft/miniconda3/bin/activate

conda activate wgs
cd /mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/02.combinevcf
inp=/mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/01.genomicsdb

date '+---- Gathergvcfs Start %y-%m-%d %H:%M:%S' > gathervcf.log
/mnt/hwstor9k_data1/junehuang/biosoft/gatk-4.2.6.1/gatk GatherVcfs \
 --INPUT ${inp}/chr1.genotype.vcf \
 --INPUT ${inp}/chr2.genotype.vcf \
 --INPUT ${inp}/chr3.genotype.vcf \
 --INPUT ${inp}/chr4.genotype.vcf \
 --INPUT ${inp}/chr5.genotype.vcf \
 --INPUT ${inp}/chr6.genotype.vcf \
 --INPUT ${inp}/chr7.genotype.vcf \
 --INPUT ${inp}/chr8.genotype.vcf \
 --INPUT ${inp}/chr9.genotype.vcf \
 --INPUT ${inp}/chr10.genotype.vcf \
 --INPUT ${inp}/chr11.genotype.vcf \
 --INPUT ${inp}/chr12.genotype.vcf \
 --INPUT ${inp}/chr13.genotype.vcf \
 --INPUT ${inp}/chr14.genotype.vcf \
 --INPUT ${inp}/chr15.genotype.vcf \
 --INPUT ${inp}/chr16.genotype.vcf \
 --INPUT ${inp}/chr17.genotype.vcf \
 --INPUT ${inp}/chr18.genotype.vcf \
 --INPUT ${inp}/chr19.genotype.vcf \
 --INPUT ${inp}/chr20.genotype.vcf \
 --INPUT ${inp}/chr21.genotype.vcf \
 --INPUT ${inp}/chr22.genotype.vcf \
 --INPUT ${inp}/chrX.genotype.vcf \
 --INPUT ${inp}/chrY.genotype.vcf \
 --INPUT ${inp}/chrM.genotype.vcf \
 --OUTPUT ./raw_final.vcf 1>> gathervcf.log 2 >&1 || exit 1
date '+--- Gathervcf End %y-%m-%d %H:%M:%S' >> gathervcf.log
