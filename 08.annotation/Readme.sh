'''
Basic filter:
Variants from exon and intron-exon junctions were recovered.
Synonymous SNV, nonframeshift deletion and nonframeshift insertion were removed.
Variant frequency filter
NHLBI-ESP 6500 exomes with MAF<0.01
Kaviar database with MAF <0.01 
gnomAD exomes with MAF<0.01 
gnomAD exomes East Asian population with MAF <0.01 
GERP++>2 or GERP++<0 

Add CADD score (CADD >= 10 or CADD >= 20)

Find if there's any gene in three HCM gene list first, then add patient ID

Use 3/9 or 4/9 algrithom to filter
'''

bash annovar.sh

cat final.hg38_multianno.txt | head -1 | tr '\t' '\n' | cat -n > annovar.col.name
# annovar.col.name
# 1:Chr:...1
# The raw row order:The col name from annovar output:The column order (almost) same as Wenjuan's spreadsheet

# Filter step by step
cat final.hg38_multianno.txt | awk '{if($6!~"^ncRNA"){print $0}}' | awk '{if($6~"exonic" || ($6~"splicing")) {print $0}}' | awk '{if($11!~"^ncRNA"){print $0}}' | awk '{if($11~"exonic" || ($11~"splicing")) {print $0}}' > final.keep.exon.splicing.txt
awk -F '\t' '{if($9!~"^unknown"){print}}' | awk -F '\t' '$9!="synonymous SNV"{print}' | awk -F '\t' '{if($14!~"^unknown"){print}}' | awk -F '\t' '$14!="synonymous SNV"{print}' > remove.synSNV.nonframeINDEL.keep.exon.splicing.txt
awk -F '\t' '{if($16<=0.01){print}}' | awk -F '\t' '{if($25<=0.01){print}}' | awk -F '\t' '{if($28<0.01){print}}' | awk -F '\t' '{if($36<0.01){print}}' | awk -F '\t' '{if(($100>2) || ($100<0)){print}}' | awk -F '\t' 'BEGIN {OFS = "\t"} {print $1,$2,$4,$5,$153,$28,$36,$86,$100,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$47,$50,$56,$59,$62,$65,$68,$73,$79,$148,$149,$150,$151,$152}' > format.maf.remove.keep.txt
cat format.maf.remove.keep.txt | awk -F '\t' '{if($8>=10) print}' > format.cadd10.maf.remove.keep.txt
# Add a column to see if the genes in our annotation output appear in the known gene list: format.cadd10.maf.remove.keep.knowngenes.highconfident.more.txt
python3 add_geneexpression.py 

# Formatted the raw vcf file to the one we want which only keeps 【chr	pos	sample's genotype(0|1, 1|2)】
final.vqsr.bedfilter.vcf.gz | grep -v '^##' | cut -f1-2,10-68 | sed 's+/+|+g' > raw.pos.gt.vcf
### To get a spreadsheet in which the patient's in the first column and don't care the variants are repetitive:
sh genotype.extract.for.each.patient.sh
# Use batch script to run add_patientID.py and you will get each patient's variant calling file whose filename is their subject ID
sh run_script.sh
# Add one column to illustrate their diagnosis
sh add_diagnosis.sh
# Combine all of the file in to one file (You may need to sort the file based on the subject ID)
cat * > final.txt
# Calculate the number of damaging calls in nine prediction algorithms
cat final.txt | awk '{count=0; for(i=21; i<30; i++){if(($i =="D")||($i =="P")||($i =="A")||($i =="H")||($i =="M"))count+=1;}print $0"\t"count}' > final.countscore.txt
# Modify the order and some of the header name to get the final spreadsheet


### If you just want the uniq variant and show patients' ID in the last column of each variant, you can try the scripts below:
# Add sample identifier(PWHxxxx) and diagnosis(ApHCM, HCM, etc.) column ######
# Create the variant position file and use it as feed to raw vcf file to find the variant's genotype
cat format.cadd10.maf.remove.keep.txt | cut -f2 > variant.pos.txt
## Create the new documentary to store the genotype for each sample and combine all the sample GT into one file
# Or use variant.pos.py to filter the useful variant first, so it won't search the whole vcf file
sh genotype.extract.sh
cat hcm.snps.VQSR.noheader.vcf | cut -f1-2 > chr.pos.col
paste chr.pos.col ./GT/genotype.col > hcm1to16.snps.VQSR.onlyGT.vcf

# 4.Get the sample name without same genotype like '0|0', '1|1' (... '6|6')  【chr	pos	sample_name】
# Better check it first to see how many kinds of gt we don't need
python3 sample.name.py  
python3 add_sampleID.py
python3 add_diagnosis.py


