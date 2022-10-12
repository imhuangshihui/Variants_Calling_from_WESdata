# SIFT < 0.05
cat MR01.hg38_multianno.filterd | awk '{if($22<=0.05)print}' 


####以下開始要重新過濾，因爲awk提取出來的第23行和cut不一樣
# PolyPhen 2 HDIV: Probably damaging (>=0.957) NUMBER: 1794
awk '{if($23>=0.957)print}'

# PolyPhen 2 HVar: Probably damaging (>=0.909) NUMBER:1659
awk '{if($25>=0.909)print}'

# LRT is deleterious or neutral, only 2 variants was selected
#awk '$28=="D"||$28=="N"{print}'

