## Choose the exonic, UTR, and splicing region

cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="exonic"{print}' > MR01.hg38_multianno.exonic
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="exonic;splicing"{print}' > MR01.hg38_multianno.exonicANDsplicing
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '$6=="splicing"{print}' > MR01.hg38_multianno.splicing
cat MR01.hg38_multianno.txt | awk -v OFS="\t" '{if($6~"UTR")print}' > MR01.hg38_multianno.UTR
cat h MR01.hg38_multianno.exonic MR01.hg38_multianno.exonicANDsplicing MR01.hg38_multianno.splicing && 
MR01.hg38_multianno.splicing MR01.hg38_multianno.UTR > MR01.hg38_multianno.filtered

# （1）AWK uses the white space to splite the fields. "Nonsynonymous SNV" was seperated to 2 fields by AWK but as 1 field by CUT.

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

# 提取rsid用於做Clinvar的注釋
# 首先先轉換爲annovar的格式
cat MR01.hg38_multianno.score_filter | cut -f20 > MR01.score.filtered.snplist.txt
# Run the script
convert2annovar.rsid.sh 
# 報錯，有可能是Humandb的數據庫不對




#(2) Extract the exonic variants first, then use score to filter the nonsynomos
cat MR01.hg38_multianno.filtered | awk -F '\t' '{if($9!="synonymous SNV")print}' | awk -F '\t' '{if($9!="unknown")print}' | cut -f9 | sort | uniq -c
  53177 .
      1 ExonicFunc.refGene
    145 frameshift deletion
     99 frameshift insertion
    229 nonframeshift deletion
    185 nonframeshift insertion
  12105 nonsynonymous SNV
     31 startloss
    129 stopgain
     15 stoploss

cat MR01.hg38_multianno.exonicfuntion | wc -l
66116

cat MR01.hg38_multianno.exonicfuntion | awk -F '\t' '{if($21<=0.05)print $21}' | wc -l
57327

awk -F '\t' '{if($23>=0.957)print}' | wc -l
820
# awk -F '\t' '{if($23>=0.453)print}' | wc -l
# 1205

awk -F '\t' '{if($25>0.909)print}' | wc -l
541
# awk -F '\t' '{if($25>0.909)print}' | wc -l
# 944

awk -F '\t' '$28!="U"{print}' | awk -F '\t' '$28!="N"{print}'
372
# awk -F '\t' '$28!="U"{print}'
# 842

awk -F '\t' '$32!="L"{print}' | awk -F '\t' '$32!="N"{print}'
275
# This condition is not change: 529

awk -F '\t' '$34!="T"{print}'
70
# 122

awk -F '\t' '$44!="T"{print}'
38
# 54

awk -F '\t' '$46!="T"{print}'
37
# 53

#Same results as the (1) method

# Filter the 12477 synonymous SNV and 363 unknown exonic function
cat MR01.hg38_multianno.filtered | awk -F '\t' '$9!="synonymous SNV"{print}' | awk -F '\t' '$9!="unknown"{print}' > MR01.hg38_multianno.filtered.synonymous

# Using the new filteration file to annotate clinvar

