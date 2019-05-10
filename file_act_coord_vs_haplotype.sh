#!/bin/bash

## usage: ./file_act_coord.sh [Chr No] [start Coord] [end Coord] [haplo contig No]
## need to put the genome sequence file (Smansoni_v7.fa) and annotation gff (Sm_v7.2_Basic.gff) in the same directory


### get sequence of range
python alan_extract_fa.py Smansoni_v7.fa SM_V7_$1 $2 $3 > SM_V7_$1_$2-$3.fa

### blast gene with contig
blastn -query SM_V7_$1_$2-$3.fa -subject SM_V7_${4}.fa -outfmt 6 > SM_V7_$1_$2-$3_$4.blast.out

### annotation for contig
grep SM_V7_$4 Sm_v7.2_Basic.gff | sort -k1,1 -k4,4n > $4.gff
bgzip -f $4.gff 
tabix -f $4.gff.gz

### annotation for selected region
declare -i START=$2
declare -i END=$3

cat Sm_v7.2_Basic.gff | awk '$1=="SM_V7_""'$1'"' | awk '$4>='$START' && $5<='$END'' | awk '{print "SM_V7_""'$1'""_""'$2'""-""'$3'",$2,$3,$4-'$START'+1, $5-'$START'+1,$6,$7,$8,$9}'|awk '$4>0'|tr ' ' '\t' |sort -k1,1 -k4,4n> SM_V7_$1_$2-$3_rel.gff

### load into ACT: SM_V7_$1_$2-$3.fa, SM_V7_${4}.fa, SM_V7_$1_$2-$3_$4.blast.out
### read after: SM_V7_$1_$2-$3_rel.gff, $4.gff.gz
