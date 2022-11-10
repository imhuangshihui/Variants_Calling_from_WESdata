(base) export VEP_PATH=/mnt/hwstor9k_data1/junehuang/biosoft/ensembl-vep
(base) export VEP_DATA=/mnt/hwstor9k_data1/junehuang/biosoft/.vep
(base) perl INSTALL.pl --AUTO cf --SPECIES homo_sapiens --ASSEMBLY GRCh38 --DESTDIR $VEP_PATH --CACHEDIR $VEP_DATA
Using non-default API installation directory /mnt/hwstor9k_data1/junehuang/biosoft/ensembl-vep.
Please note this just specifies the location for downloaded API files. The vep script will remain in its current location where ensembl-vep was unzipped.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PLEASE REMEMBER TO 
1. add /mnt/hwstor9k_data1/junehuang/biosoft/ensembl-vep to your PERL5LIB environment variable
2. add /mnt/hwstor9k_data1/junehuang/biosoft/ensembl-vep/htslib to your PATH environment variable
 - getting list of available cache files
 - downloading https://ftp.ensembl.org/pub/release-108/variation/indexed_vep_cache/homo_sapiens_vep_108_GRCh38.tar.gz
 - unpacking homo_sapiens_vep_108_GRCh38.tar.gz
 - converting cache, this may take some time but will allow VEP to look up variants and frequency data much faster
 - use CTRL-C to cancel if you do not wish to convert this cache now (you may run convert_cache.pl later)
2022-11-10 11:04:22 - Processing homo_sapiens
2022-11-10 11:04:22 - Processing version 108_GRCh38
2022-11-10 11:04:22 - No unprocessed types remaining, skipping
2022-11-10 11:04:22 - All done!
 - downloading Homo_sapiens.GRCh38.dna.toplevel.fa.gz
 - downloading Homo_sapiens.GRCh38.dna.toplevel.fa.gz.fai
 - downloading Homo_sapiens.GRCh38.dna.toplevel.fa.gz.gzi

The FASTA file should be automatically detected by the VEP when using --cache or --offline.
If it is not, use "--fasta /mnt/hwstor9k_data1/junehuang/biosoft/.vep/homo_sapiens/108_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz"


All done
(base) export PERL5LIB=$VEP_PATH:$PERL5LIB
(base) export PATH=$VEP_PATH/htslib:$PATH
(base) export PERL5LIB=$VEP_PATH:$PERL5LIB
(base) export PATH=$VEP_PATH/htslib:$PATH
(base) mkdir $VEP_PATH/samtools && cd $VEP_PATH/samtools
(base) curl -LOOO https://github.com/samtools/{samtools/releases/download/1.4.1/samtools-1.4.1,bcftools/releases/download/1.4.1/bcftools-1.4.1,htslib/releases/download/1.4.1/htslib-1.4.1}.tar.bz2
(base) cat *tar.bz2 | tar -ijxf -
(base) cd htslib-1.4.1 && make && make prefix=$VEP_PATH/samtools install && cd ..
(base) cd samtools-1.4.1 && make && make prefix=$VEP_PATH/samtools install && cd ..
(base) cd bcftools-1.4.1 && make && make prefix=$VEP_PATH/samtools install && cd ..
(base) cd ..
(base) curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver --output liftOver
(base) chmod a+x liftOver
(base) export PATH=/mnt/hwstor9k_data1/junehuang/biosoft/ensembl-vep/samtools/bin:$
(base) curl -L ftp://ftp.broadinstitute.org:/pub/ExAC_release/release0.3.1/subsets/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz --output ./.vep/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
(base) echo "##FILTER=<ID=AC_Adj0_Filter,Description=\"Only low quality genotype calls containing alternate alleles are present\">" > header_line.tmp
(base) curl -LO https://raw.githubusercontent.com/mskcc/vcf2maf/v1.6.16/data/known_somatic_sites.bed
(base) bcftools annotate --header-lines header_line.tmp --remove FMT,^INF/AF,INF/AC,INF/AN,INF/AC_Adj,INF/AN_Adj,INF/AC_AFR,INF/AC_AMR,INF/AC_EAS,INF/AC_FIN,INF/AC_NFE,INF/AC_OTH,INF/AC_SAS,INF/AN_AFR,INF/AN_AMR,INF/AN_EAS,INF/AN_FIN,INF/AN_NFE,INF/AN_OTH,INF/AN_SAS ./.vep/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz | bcftools filter --targets-file ^known_somatic_sites.bed --output-type z --output $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.fixed.vcf.gz
(base) chmod a+x ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
[E::hts_open_format] fail to open file './.vep/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz'
Failed to open ./.vep/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz: No such file or directory
Failed to open -: unknown file type
(base) ./vep --species homo_sapiens --assembly GRCh38 --offline --no_progress --no_stats --sift b --ccds --uniprot --hgvs --symbol --numbers --domains --gene_phenotype --canonical --protein --biotype --uniprot --tsl --pubmed --variant_class --shift_hgvs 1 --check_existing --total_length --allele_number --no_escape --xref_refseq --failed 1 --vcf --minimal --flag_pick_allele --pick_order canonical,tsl,biotype,rank,ccds,length --dir $VEP_DATA --fasta $VEP_DATA/homo_sapiens/$VER\_GRCh38/Homo_sapiens.GRCh38.dna.toplevel.fa.gz --input_file examples/homo_sapiens_GRCh38.vcf --output_file examples/homo_sapiens_GRCh38.vep.vcf --polyphen b --af --af_1kg --af_esp --regulatory