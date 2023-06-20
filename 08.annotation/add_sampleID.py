f1 = open('format.maf.remove.keep.txt', 'r')
anno = f1.readlines()
f2 = open('format.maf.remove.keep.withID.txt', 'w')
with open('sample.name.txt', 'r') as f3:
    lines = f3.readlines()
    for line in lines:
        line = line.strip().split('\t')
        # print(line[2])
        for var in anno:
            pos = var.strip().split('\t')
            if line[1] in pos[1]:
                if len(line) == 3:
                    f2.write(var.strip())
                    f2.write('\t')
                    f2.write(str(line[2]) + '\n')
                else:
                    f2.write(var.strip() + '\n')
f1.close()
f2.close()
