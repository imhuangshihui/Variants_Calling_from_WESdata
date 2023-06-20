#This script is used to find the significant variant's phoenotype (0|1, 1|2, etc.) 
#From the raw vcf file which has the total variants
#By using their start position
#In order to improve the running time of later scripts

from typing import List

with open('variant.pos.txt', 'r') as f:
    pos_lis: List[str] = [pos.rstrip() for pos in f]
#    print(genes)
# variant_pos.txt include the variant start pos after the step23456 filtering step

out = open("final.pos.gt.vcf", "w")
with open('raw.pos.gt.vcf', 'r') as f1:
    lines = f1.readlines()
    for line in lines:
        pos = line.strip().split("\t")
        # print(line[6])
        if pos[1] in pos_lis:
            out.write(line)
        

