import sys

source = open('/mnt/hwstor9k_data1/junehuang/wes_hcm/rawdata/04.newanno/format.cadd10.maf.remove.keep.knowngenes.highconfident.more.txt', 'r')
anno = source.readlines()

nogt = ['.|.', '0|0']

with open(sys.argv[1], 'r') as f1:
    lines = f1.readlines()
    header = lines[0].strip().split('\t')
    result = open(header[2], 'w')
    for line in lines:
        line = line.strip().split('\t')
        if line[2] not in nogt:
            for var in anno:
                pos = var.strip().split('\t')
                if pos[1] in line[1]:
                    pos = '\t'.join(pos)
                    result.write(header[2])
                    result.write('\t')
                    result.write(pos + '\n')


source.close()
result.close()


