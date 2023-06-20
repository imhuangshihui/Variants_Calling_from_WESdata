from typing import List

nogt = ['0|0', '.|.', '1|1', '2|2', '3|3', '4|4', '5|5', '6|6']
result = open('sample.name.txt', 'w')
with open('final.pos.onlygt.vcf', 'r') as file:
    lines = file.readlines()
    header = lines[0].rstrip().split('\t')
    for line in lines:
        line = line.strip().split('\t')
        result.write(str(line[0]))
        result.write('\t')
        result.write(str(line[1]))
        result.write('\t')
        for i,element in enumerate(line):
            if element not in nogt:
                result.write(str(header[i]))
                result.write(',')
        result.write('\n')
result.close()

