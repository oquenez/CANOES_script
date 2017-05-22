#!/bin/sh
readcount=$1
target=$2
out=$3
intersectBed -a $readcount -b $target | cut -f1-3 | sort | uniq > selectedTarget.txt
while read line; do grep -n -e "$line" $readcount; done < selectedTarget.txt > readsLineNb.txt
awk -F"\t" '{OFS="\t";print $1,$2,$3}' readsLineNb.txt | sed -e "s/:/\t/g" | awk -F"\t" 'BEGIN {print "SAMPLE;CNV;INTERVAL;KB;CHR;MID_BP;TARGETS;NUM_TARG;MLCN;Q_SOME"}''{printf "\"SAMPLE\";\"DUP\";\""$2":"$3"-"$4"\";"$4-$3";"$2";%i;\""$1".."$1"\";"$1";3;99\n", ($4+$3)/2}' > $out
rm selectedTarget.txt readsLineNb.txt
