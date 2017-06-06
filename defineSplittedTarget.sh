reads=$1	#fichier d'origine contenant le comptage de reads
target=$2	#fichier contenant les cibles à rechercher pour le génotyapge
name=$3		#nom à donner à la cible
batch=$4	#nom du batch analysé
cut -f1-3 $reads > .tmp
intersectBed -a .tmp -b $target -wa > .tmp2
sort .tmp2 | uniq | cut -f2 > .tmp3
while read line; do grep -n $line .tmp; done < .tmp3 | sed -e "s/:/\t/" > .tmp4
echo "SAMPLE;CNV;INTERVAL;KB;CHR;MID_BP;TARGETS;NUM_TARG;MLCN;Q_SOME" > $name.$batch.target.csv
awk -F"\t" '{OFS="";print "\"SAMPLE\";\"DUP\";\"",$2,":"$3,"-",$4,"\";",$4-$3,";",($3+$4)/2,";",$2,";\"",$1,"..",$1,"\";1;3;99"}' .tmp4 >>  $name.$batch.target.csv

rm .tmp .tmp2 .tmp3 .tmp4

