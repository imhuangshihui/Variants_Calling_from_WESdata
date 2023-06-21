samtools stats PWHA000${i}.sorted.markdup.recal.bam > PWHA000${i}.stats
cat PWHA000${i}.stats | grep 'raw total sequences'
cat PWHA000${i}.stats | grep 'reads duplicated'


samtools depth PWHA000${i}.sorted.markdup.recal.bam -b S07604514_Regions.bed > PWHA000${i}.depth
cat PWHA000${i}.depth | awk '{sum+=$3} END {print sum/NR}'
