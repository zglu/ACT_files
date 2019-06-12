#!/usr/bin/env python

'''

For getting sequence in a region of a particular scaffold

python3 ~/python/bin/fasta_extract_by_coords.py Smansoni_v7.fa SM_V7_W001 500 1000

'''

# script from Alan
# IMPORTS

import re
import sys
import Bio
from Bio import SeqIO
from Bio.Alphabet import generic_dna

Ns={}

ctg= sys.argv[2]
fasta=sys.argv[1]
coords1 = sys.argv[3]
coords2 = sys.argv[4]

with open(fasta, "r") as f:
	for seq_record in SeqIO.parse(f, "fasta"):
		if ctg == seq_record.id:
			a=int(coords1)-1
			b=int(coords2)
			print('>'+str(ctg)+'_'+str(a+1)+'-'+str(b)+'\n'+seq_record.seq[a:b])
