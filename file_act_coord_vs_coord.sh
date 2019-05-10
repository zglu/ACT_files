#!/bin/bash

## usage: ./file_act_coord.sh [Chr1 No] [start Coord] [end Coord] [Chr2 No] [start coord] [end coord]
## need to put the genome sequence file (Smansoni_v7.fa) and annotation gff (Sm_v7.2_all-validated.gff) in the same directory


### get sequence of range
python alan_extract_fa.py Smansoni_v7.fa SM_V7_$1 $2 $3 > SM_V7_$1_$2-$3.fa
python alan_extract_fa.py Smansoni_v7.fa SM_V7_$4 $5 $6 > SM_V7_$4_$5-$6.fa

### blast two regions
blastn -query SM_V7_$1_$2-$3.fa -subject  SM_V7_$4_$5-$6.fa -outfmt 6 > SM_V7_$1_$2-$3_vs_$4_$5-$6.blast.out

### annotation for selected region
declare -i START1=$2
declare -i END1=$3
declare -i START2=$5
declare -i END2=$6


cat Sm_v7.2_all-validated.gff | awk '$1=="SM_V7_""'$1'"' | awk '$4>='$START1' && $5<='$END1'' | awk '{print "SM_V7_""'$1'""_""'$2'""-""'$3'" "\t" $2 "\t" $3 "\t" $4-'$START1'+1 "\t" $5-'$START1'+1 "\t "$6 "\t" $7 "\t" $8 "\t" $9}'|awk '$4>0'|sort -k1,1 -k4,4n> SM_V7_$1_$2-$3_rel.gff

cat Sm_v7.2_all-validated.gff | awk '$1=="SM_V7_""'$4'"' | awk '$4>='$START2' && $5<='$END2'' | awk '{print "SM_V7_""'$4'""_""'$5'""-""'$6'" "\t" $2 "\t" $3 "\t" $4-'$START2'+1 "\t" $5-'$START2'+1 "\t "$6 "\t" $7 "\t" $8 "\t" $9}'|awk '$4>0'|sort -k1,1 -k4,4n> SM_V7_$4_$5-$6_rel.gff

### load into ACT: SM_V7_$1_$2-$3.fa, SM_V7_$4_$5-$6.fa,  SM_V7_$1_$2-$3_vs_$4_$5-$6.blast.out
### read after: SM_V7_$1_$2-$3_rel.gff, SM_V7_$4_$5-$6_rel.gff
