#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J splitFeatureFiles_handles
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/splitFeatureFiles_handles_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/splitFeatureFiles_handles_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=24G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/featureWiseGTF"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/featureWiseGTF/handles_split"
inFileName="modLib_trimmed_filtered_m45-M4000_seqkit.locate_handles.gtf"
inputFile=${inFileName}/${inFileName} 

# Read through input file's first column and append the line to the respective .gtf file
while IFS=$'\t' read -r col1 rest; do
    echo "$col1 $rest" >> "${outDir}/${col1}.gtf"
done < "$inputFile"
