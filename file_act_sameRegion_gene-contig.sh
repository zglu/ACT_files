#!/bin/bash

## provide a gene and a contig, get the same length of chromosome region (containing the gene) as the contig, produce region fa, region gff, region-contig blast out files for ACT

## usage: ./get.sh [Smp id] [contig no]
## eg ./get.sh Smp_093620 2H004

START="$(grep gene Sm_v7.2_Basic.gff|grep $1 | awk '{print $4}')"

ConLen="$(grep $2 v7-contig-lengths.txt | awk '{print $2}')"

chr="$(echo $2 |cut -c1-1)"
newstart=$((START-ConLen/2))
newend=$((START+ConLen/2))

#echo $chr $newstart $newend

### get sequence of range
python alan_extract_fa.py Smansoni_v7.fa SM_V7_$chr $newstart $newend > SM_V7_${chr}_$newstart-$newend.fa

### blast gene with contig
blastn -query SM_V7_${chr}_$newstart-$newend.fa -subject SM_V7_${2}.fa -outfmt 6 > SM_V7_${chr}_${newstart}-${newend}_$2.blast.out

### annotation for contig
grep SM_V7_$2 Sm_v7.2_Basic.gff | sort -k1,1 -k4,4n > $2.gff
bgzip -f $2.gff
tabix -f $2.gff.gz

### annotation for selected region

cat Sm_v7.2_Basic.gff | awk '$1=="SM_V7_""'$chr'"' | awk '$4>='$newstart' && $5<='$newend'' | awk '{print "SM_V7_""'$chr'""_""'$newstart'""-""'$newend'",$2,$3,$4-'$newstart'+1, $5-'$newstart'+1,$6,$7,$8,$9}'|awk '$4>0'|tr ' ' '\t' |sort -k1,1 -k4,4n> SM_V7_${chr}_${newstart}-${newend}_rel.gff

### load into ACT: SM_V7_$1_$2-$3.fa, SM_V7_${4}.fa, SM_V7_$1_$2-$3_$4.blast.out
### read after: SM_V7_$1_$2-$3_rel.gff, $4.gff.gz
