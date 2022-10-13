## Choose the exonic, UTR, and splicing region

cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="exonic"{print}' > MR01.hg38_multianno.exonic
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="exonic;splicing"{print}' > MR01.hg38_multianno.exonicANDsplicing
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="splicing"{print}' > MR01.hg38_multianno.splicing
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '{if($6~"UTR")print}' > MR01.hg38_multianno.UTR
cat h MR01.hg38_multianno.exonic MR01.hg38_multianno.exonicANDsplicing MR01.hg38_multianno.splicing && 
MR01.hg38_multianno.splicing MR01.hg38_multianno.UTR > MR01.hg38_multianno.filtered

# AWK uses the white space to splite the fields. "Nonsynonymous SNV" was seperated to 2 fields by AWK but as 1 field by CUT.

## Filter by score

# MR01.hg38_multianno.filtered 78956

# SIFT < 0.05
cat MR01.hg38_multianno.filtered | awk -F '\t' '{if($21<=0.05)print}'

# PolyPhen 2 HDIV: Probably damaging (>=0.957) 
awk -F '\t' '{if($23>=0.957)print}'

# PolyPhen 2 HVar: Probably damaging (>=0.909) 
awk -F '\t' '{if($25>0.909)print}'

# LRT is deleterious
awk -F '\t' '$28!="U"{print}' | awk -F '\t' '$28!="N"{print}'

# MutationAssessor (ma) choose high or medium. H/M means functional 
awk -F '\t' '$32!="L"{print}' | awk -F '\t' '$32!="N"{print}'

# FATHMM (fathmm) Deleterious
awk -F '\t' '$34!="T"{print}'

# MetaSVM (metasvm) D: Deleterious
awk -F '\t' '$44!="T"{print}'

# MetaLR (metalr) D: Deleterious
awk -F '\t' '$46!="T"{print}' >MR01.hg38_multianno.score_filter  

#####Using all kinds of score to filter the vcf, the final variant number is 39.#####



## 用rs編號去NCBI Clinvar看這些變異是否有人報道過



