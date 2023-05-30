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
makeblastdb -in contigs.fasta -dbtype nucl -parse_seqids
blastn -db contigs.fasta -query CP015498.fasta > blast.rez

#Comparing and describing gene predictions:
#ERR204044 assembly:
#Number of predicted genes: RAST- 2564, GeneMarks- 2311 and BLAST- 1813
#SRR15131330 assembly:
#Number of predicted genes: RAST- 2772, GeneMarks- 2550 and BLAST- 1909
#SRR18214264 assembly:
#Number of predicted genes: RAST- 2521, GeneMarks- 2338 and BLAST- 1811
#
#Predictions created by BLAST had the smallest amount of predicted genes, and RAST had the biggest. Also, number of predicted
#genes, are very similar in ERR204044 and SRR18214264 assemblies, accross all the different tools that were used to make 
#predictions.

#Create a phylogenetic tree from 16S sequences
muscle -in 16s.fasta -out 16s.aln

+-----------------------------------------------------------Staphylococcus_16S
|
|  +**16S_ERR204044_NODE_122_107-1667
+--|
|  +**16S_SRR18214264_NODE_123_107-1667
|
|     +--16S_SRR15131330_NODE_139_4-956
|  +**|
|  |  |  +**16S_CP015498.1_94173-95733
|  |  +**|
|  |     +**16S_CP015498.1_474525-476085
+--|
   +**16S_SRR15131330_NODE_148_0-603

#Multi-gene tree
muscle -in multi.fasta -out multi.aln

+--Staphylococcus_16S
|
|     +**16S_ERR204044_NODE_122_107-1667
|  +**|
|  |  +**16S_SRR18214264_NODE_123_107-1667
+--|
|  |                                      +**Glucokinase
|  |                           +----------|
|  |                           |          +-----------------Protein_translocase_subunit_SecA
|  |              +------------|
|  |              |            +--------Penicillin-binding_protein
|  |           +--|
|  |           |  +-----------------Ribonuclease_III
|  +-----------|
|              +-------------Histidine_tRNA_ligase
|
|        +--16S_SRR15131330_NODE_139_4-956
|     +**|
|     |  +**16S_CP015498.1_94173-95733
|  +**|
|  |  +**16S_CP015498.1_474525-476085
+--|
   +**16S_SRR15131330_NODE_148_0-603