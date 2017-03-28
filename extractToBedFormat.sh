#!/bin/bash
while read line; 
do IFS=';' read -ra ADDR <<< "$line"; 
	echo -e "${ADDR[3]}\t${ADDR[1]}\t${ADDR[2]}\t${ADDR[4]}\t${ADDR[8]}\t${ADDR[9]}\t${ADDR[10]}"; 
done < $1 | sed -e "s/:/\t/" | sed -e "s/-/\t/" | sed -e 's/\"//g' | grep -v INTERVAL
