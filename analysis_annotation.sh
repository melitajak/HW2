#!/bin/bash

#Using Gepard tool create dotplots to show similarities/dissimilarities:
#Samples are all similar, they all have a diagonal lines formed by connected dots that represents similar regions 
#or alignments between the sequences. There are few but not many indels represented in the dot plot. Also there
#are no repeats, so sequences do not contain significant repetitive elements or duplications.

#Using BUSCO analysis tool, evaluate your assemblies:
#All three assemblies show high completeness, with over 98% of the BUSCO groups being found. Almost all of the identified 
#BUSCOs are complete and single-copy, indicating good quality and representation of essential genes. However, there are a 
#few fragmented and missing BUSCOs, suggesting potential gaps or errors in the assemblies. 

#BLAST 
#nucleo
makeblastdb -in contigs.fasta -dbtype nucl -parse_seqids
blastn -db contigs.fasta -query CP015498nucl.fasta > blast_nucl.rez
#protein
makeblastdb -in ERRcontigs.fasta -dbtype prot -parse_seqids
tblastn -db ERRcontigs.fasta -query CP015498prot.fasta -outfmt 6 -out ERRoutput.txt > blast_prot.rez

#Comparing and describing gene predictions:
#ERR204044 assembly:
#Number of predicted genes: RAST- 2564, GeneMarks- 2311 and BLAST nucl- 1813, prot- 2091
#SRR15131330 assembly:
#Number of predicted genes: RAST- 2772, GeneMarks- 2550 and BLAST nucl- 1909, prot-2095
#SRR18214264 assembly:
#Number of predicted genes: RAST- 2521, GeneMarks- 2338 and BLAST nucl- 1811, prot- 2089
#
#Predictions created by BLAST had the smallest amount of predicted genes, and RAST had the biggest. Also, number of predicted
#genes, are very similar in ERR204044 and SRR18214264 assemblies, accross all the different tools that were used to make 
#predictions. 

#Create a phylogenetic tree from 16S sequences
#aligning files
muscle -in 16s.fasta -out 16s.aln

#Multi-gene tree
#aligning files
muscle -in multi.fasta -out multi.aln

#Comparing trees:
#From the trees we can see same tendency that ERR204044 with SRR18214264 and SRR15131330 with CP015498 always end up in the same 
#clusters. Also we can see that Staphylococus is usually not in in the same clusters with assemblies or reference.

#Using all data, identify if any of genomes are more similar to each other than to the third one (or reference genome):
#Genomes ERR204044 and SRR18214264 are more simmilar to each other, we can see it in the phylogenetic trees and also
#they have very simmilar predicted genes count, as well as closer coverage than SRR15131330 sample. Closest to the reference genome
#is SRR15131330, as we can see it in the phylogenetic trees.
