#!/bin/bash

cnvFile=$1;
geneFile=$2;
ext=$3;
out=$4;

intersectBed -a $cnvFile -b $geneFile -wa > $out.$ext.bed
intersectBed -a $out.$ext.bed -b /opt/REFERENCE/refSeqmiRNA.bed -wo > tmp 

perl /opt/CANOES/compilBedFromCANOES.pl --in tmp --out $out.$ext.annotated.bed
rm $out.$ext.bed tmp
