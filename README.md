# Identification of rare variants in patients with Hypertrophic cardiomyopathy (HCM) by  whole exome sequencing (WES)

## Abstract

Hypertrophic Cardiomyopathy (HCM) is a leading cause of sudden cardiac death among young adults. It was reported that there were 76 genes known to cause HCM. Genetic testing offers insight into disease mechanisms and pathogenicity. Whole Exome Sequencing (WES) is a cost-effective way in which researchers can focus their resources on the genes most likely to affect phenotype by sequencing only the coding regions of the genome. In our Hong Kong cohort study, we sequenced 60 patients with HCM by WES data to better understand the candidate pathogenic variants that contribute to the development of the disease. In total, 14, 852 rare sequence variants recovered. 39 (51.3%) genes comprising 181 variants in known HCM gene list and 4 genes with 5 variants predicted as “Pathogenic” or “Likely Pathogenic” by ClinVar. We also found 86 genes comprising 93 variants not in the known HCM gene list were identified as “Pathogenic” or “Likely Pathogenic” by ClinVar. They affected 52 patients among which 38 of them have multiple pathogenic variants.​ We hope this study can provide insights into the genetic basis of HCM and aid in developing molecular-level diagnosis.

## Method

- Quality control, genome mapped and alignment by Fastp, BAM MEM, and Samtools
- Variant calling by GATK Best Practices and annotated by ANNOVAR
- Filtered candidate pathogenic HCM genes with various pathogenicity prediction algorithms and databases including CLINVAR
- Dug into clinical significance, interpretation the causative mutations and genes

> Variant Filter Criteria
> 
> Variants from exon and intron-exon junctions were recovered.
> 
> Synonymous SNV, nonframeshift deletion and nonframeshift insertion were removed.
> 
> Variant frequency filter :​
>> NHLBI-ESP 6500 exomes with MAF<0.01;
>> Kaviar database with MAF <0.01;
>> gnomAD exomes with MAF<0.01;
>> gnomAD exomes East Asian population with MAF <0.01;
>> GERP++>2 or GERP++<0;
>> CADD > 10​

