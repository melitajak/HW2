#!/bin/bash

threads=6
inputs_dir="$HOME/HW2/inputs"
outputs_dir="$HOME/HW2/outputs"

#Data QA/QC
prefetch -O ~/HW2/inputs ERR204044 SRR15131330 SRR18214264
fastq-dump --outdir ~/HW2/inputs --split-files ~/HW2/inputs/SRR15131330 ~/HW2/inputs/SRR18214264 ~/HW2/inputs/ERR204044

#Quality check raw data
fastqc -t ${threads} ${inputs_dir}/*.trimmed.fastq -o ${outputs_dir}/raw_data
#Number of duplicate reads is high in the SRR15131330 sample. Mean quality score 
#is overall high exept for ERR204044_2 sample, the score is average. Adapter content 
#is also good.

#Trimming
for i in ${inputs_dir}/*_1.fastq;
do
  R1=${i};
  R2="${inputs_dir}/"$(basename ${i} _1.fastq)"_2.fastq";
  trim_galore -j ${threads} -o ${outputs_dir} --paired --length 20 ${R1} ${R2}
done

#Quality check trimmed data
fastqc -t ${threads} ${outputs_dir}/*.fq -o ${outputs_dir}
#Quality trimming discarded reads that are shorter than 20, there weren't high
#content of adapters to trim. However, the issue o high duplicate reads in 
#SRR15131330 sample and lower mean quality score in ERR204044_2 sample persisted.

multiqc -o ${outputs_dir} ${outputs_dir}
