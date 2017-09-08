bedtools merge -d 30 -i $1 > tmp
sort -k 1,1 -k2,2n tmp 
rm tmp
