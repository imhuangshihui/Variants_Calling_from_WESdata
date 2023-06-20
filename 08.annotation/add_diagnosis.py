# Add one column which identify the specific disease name
# Create a dictionary for phenotype

# Exclude the sample PWHA000268_DA and PWHA000268_SO whose diagnosis are HCM
pheno = {'ApHCM': ['PWHA000037','PWHA000101','PWHA000103','PWHA000157','PWHA000159','PWHA000162',
        'PWHA000163','PWHA000165','PWHA000172','PWHA000236','PWHA000244','PWHA000249','PWHA000250',
        'PWHA000268','PWHA000271','PWHA000285','PWHA000288','PWHA000290','PWHA000291','PWHA000294',
        'PWHA000297','PWHA000298','PWHA000304','PWHA000315','PWHA000321','PWHA000328','PWHA000335',
        'PWHA000148','PWHA000234','PWHA000327','PWHA000337'],
         'HCM': ['PWHA000306','PWHA000024','PWHA000052',
                 'PWHA000059','PWHA000086','PWHA000096','PWHA000097','PWHA000102','PWHA000109',
                 'PWHA000111', 'PWHA000268-DA', 'PWHA000268-SO'],
         'HCM(mixed)': ['PWHA000309','PWHA000013'],
         'HOCM': ['PWHA000003','PWHA000026','PWHA000031','PWHA000036','PWHA000039','PWHA000043',
                  'PWHA000048','PWHA000063','PWHA000072','PWHA000074','PWHA000095','PWHA000100',
                  'PWHA000108','PWHA000113'],
         'LongQT': 'QT0001'}
# for key, val in pheno.items():
#     print(key, val)
final = open('format.maf.remove.keep.withID.DN.txt', 'w')

with open('format.maf.remove.keep.withID.txt', 'r') as f:
    lines = f.readlines()
    for line in lines:
        ele = line.strip().split('\t')
        ele[-1] = ele[-1].strip(',')
        id_list = ele[-1].strip().split(',')
        dn = []
        for id in id_list:
            for k, v in pheno.items():
                if id in v:
                    if id not in dn:
                        dn.append(k)
                    else:
                        dn
        dn = ','.join(dn)
        final.write(line.strip() + '\t')
        final.write(dn + '\n')
final.close()
