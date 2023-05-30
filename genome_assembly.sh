#!/bin/bash

threads=6
inputs_dir="$HOME/HW2/inputs"
outputs_dir="$HOME/HW2/outputs"
refs_dir="$HOME/HW2/refs"

#Genome assembly
#Assemble genomes using spades
input_prefixes=("ERR204044" "SRR15131330" "SRR18214264")
for prefix in "${input_prefixes[@]}"; do
  spades.py --pe1-1 "${inputs_dir}/${prefix}_1_val_1.fq" --pe1-2 "${inputs_dir}/${prefix}_2_val_2.fq" -o "${outputs_dir}/spades/${prefix}"
done

#Assemble alternative genomes using ABySS. Software KmerGenie was used to estimate the best k-mer length for sample. 
abyss-pe k=91 name=ERR204044 in="ERR204044_1_val_1.fq ERR204044_2_val_2.fq"
abyss-pe k=121 name=SRR15131330 in="SRR15131330_1_val_1.fq SRR15131330_2_val_2.fq"
abyss-pe k=27 name=SRR18214264 in="SRR18214264_1_val_1.fq SRR18214264_2_val_2.fq"

#Quast results:
#Galaxy was used to run Quast for the samples. The quality of three assemblies of the different samples
#show both similarities and differences. All assemblies have similar genome fraction, meaning that 
#there was a similar percentage of aligned bases in the reference genome covered by the assembly. Also 
#the largest alignment size is the same across all results, which means that there was a common genomic 
#regions in the reference. The duplication ratios are close to 1 for all assemblies, meaning a minimal 
#level of duplication in the assembled samples. As for the differences, the size of the largest contig 
#vary among the assemblies. Samples ERR204044 and SRR18214264 have similar largest contig length (~130 0000),
#but SRR15131330 sample has a very different length (~56 000). SRR15131330 samples contig length, however, is 
#closer to the largest alignment size compared to the other samples, which suggests that the SRR15131330 
#assembly has a relatively better alignment with the reference genome. This assembly also has a lowest number
#of misassemblies and mismatches per 100 kbp.

#scaffolds were made in local machine using ragtag, using command like this for all contigs:
#ragtag.py scaffold -o ragtag_scaffolds CP015498.fasta contigs.fasta

#Selecting the better assembly for each sample:
#ERR204044- Based on Quast results, the SPAdes assembly shows a slightly higher genome fraction than ABySS 
#(77% compared to 75%) and a lower number of misassemblies than ABySS (124 compared to 145). Therefore, 
#the SPAdes assembly can be choosen as better assembly for ERR204044 sample.
#SRR15131330- Based on Quast results, assemblies overall are quite alike. Same as with the previous sample 
#the SPAdes assembly shows a higher genome fraction, although, they are simmilar (82% compared to 81%). 
#SPAdes assembly also shows lower number of misassemblies than ABySS (108 compared to 124). Therefore, 
#the SPAdes assembly can be choosen as better assembly for SRR15131330 sample.
#SRR18214264- Based on Quast results, the SPAdes assembly shows a higher genome fraction (77% compared to 69%).
#The SPAdes assembly has a largest contig size of 103582, while the ABySS assembly has a largest contig size of 54442.
#However, the largest alignment size for the first assembly is 51210, but for the second assembly, it is 24427. 
#Comparing this, the SPAdes has a larger largest contig size than the ABySS, but it also has a larger largest 
#alignment size, which means that the larger contig in the SPAdes assembly aligns well to the reference genome, 
#making it a more reliable representation of the genome and a better assembly choice for sample SRR18214264.

#Mapping
#For indexes previously selected assemblies were used, relocated to refs directory for easier access.
bwa index "${refs_dir}/ERR204044.fasta"
bwa index "${refs_dir}/SRR15131330.fasta"
bwa index "${refs_dir}/SRR18214264.fasta"

# Map to ERR204044 assembly
bwa mem -t ${threads} -o ${outputs_dir}/map/ERR204044.sam ${refs_dir}/ERR204044.fasta ${outputs_dir}/ERR204044_1_val_1.fq ${outputs_dir}/ERR204044_2_val_2.fq 
samtools view -@ ${threads} -bS -o ${outputs_dir}/map/ERR204044.bam ${outputs_dir}/map/ERR204044.sam
samtools sort -@ ${threads} -o ${outputs_dir}/map/ERR204044.sorted.bam ${outputs_dir}/map/ERR204044.bam

# Map to SRR15131330 assembly
bwa mem -t ${threads} -o ${outputs_dir}/map/SRR15131330.sam ${refs_dir}/SRR15131330.fasta ${outputs_dir}/SRR15131330_1_val_1.fq ${outputs_dir}/SRR15131330_2_val_2.fq 
samtools view -@ ${threads} -bS -o ${outputs_dir}/map/SRR15131330.bam ${outputs_dir}/map/SRR15131330.sam
samtools sort -@ ${threads} -o ${outputs_dir}/map/SRR15131330.sorted.bam ${outputs_dir}/map/SRR15131330.bam

# Map to SRR18214264 assembly
bwa mem -t ${threads} -o ${outputs_dir}/map/SRR18214264.sam ${refs_dir}/SRR18214264.fasta ${outputs_dir}/SRR18214264_1_val_1.fq ${outputs_dir}/SRR18214264_2_val_2.fq 
samtools view -@ ${threads} -bS -o ${outputs_dir}/map/SRR18214264.bam ${outputs_dir}/map/SRR18214264.sam
samtools sort -@ ${threads} -o ${outputs_dir}/map/SRR18214264.sorted.bam ${outputs_dir}/map/SRR18214264.bam
done

#Evaluating mapping fraction and genome coverage for each sample
#Mapping evaluation was done using samtools flagstat, coverage was calculated using samtools depth and getting the average
#coverage of the reads. ERR204044 read had 99.72% fraction, which indicates that it was successfully mapped to the reference 
#genome, as for coverage this read had 293x. SRR15131330 read had 99.84% fraction, which indicates that it was successfully 
#mapped to the reference genome, as for coverage this read had 2194x. SRR18214264 read had 99.73% fraction, which indicates 
#that it was successfully mapped to the reference genome, as for coverage this read had 276x.





