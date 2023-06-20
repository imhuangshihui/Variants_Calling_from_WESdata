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
# Create the variant position file and use it as feed to raw vcf file to find the variant's genotype
cat format.cadd10.maf.remove.keep.txt | cut -f2 > variant.pos.txt
# Input: variant.pos.txt, raw.pos.gt.vcf; Output: final.pos.gt.vcf (same format with raw.pos.gt.vcf but only include the variants after the filteration)
python3 variant.pos.py

mkdir GT
for i in {3..61}
do
        cat final.pos.gt.vcf | cut -f${i} | cut -d ':' -f1 > ./GT/pwh${i}
done
cd GT
mv pwh3 pwh03
mv pwh4 pwh04
mv pwh5 pwh05
mv pwh6 pwh06
mv pwh7 pwh07
mv pwh8 pwh08
mv pwh9 pwh09
paste $(ls -1 | sort) > genotype.col
paste chr.pos.col genotype.col > final.pos.onlygt.vcf

# Input: final.pos.onlygt.vcf; Output: sample.name.txt (Below shows the format of output file)
#chr1    930165  PWHA000101,PWHA000271,
#chr1    939436  PWHA000290,PWHA000297,
#chr1    942791  PWHA000024,
#chr1    943287  PWHA000163,
#chr1    943379  PWHA000109,PWHA000335,
#chr1    944004  PWHA000072,PWHA000095,PWHA000327,

python3 sample.name.py

# Input: format.maf.remove.keep.txt and sample.name.txt; Output: format.maf.remove.keep.withID.txt
python3 add_sampleID.py

# Here use the python script (NOT THE BASH SCRIPT USED ABOVE) 
python3 add_diagnosis.py



