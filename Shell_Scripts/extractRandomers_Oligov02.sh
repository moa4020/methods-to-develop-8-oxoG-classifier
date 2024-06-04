#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J extractRandomers_Oligov02
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/extractRandomers_Oligov02_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/extractRandomers_Oligov02_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=16

# Define the path to seqkit executable
seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

# Define input and output file paths
readIds="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/v02/test1/FAW63250_RandomerRightHandle_uniqueReadIDs.txt"
refTab="/athena/cayuga_0003/scratch/moa4020/8-oxoG/fasta/v02/FAW63250_comb_idtrim_trimmed.tsv"
outTab="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/v02/test1/FAW63250_RandomerRightHandleContainingSequences.tsv"
outFASTA="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/v02/test1/FAW63250_RandomerRightHandleContainingSequences.fasta"

# Use xargs to parallelize the grep command
find "$refTab" -type f -print0 | xargs -0 -P 16 grep -F -f "$readIds" > "$outTab"

# Perform sequence extraction using seqkit
"$seqkit" tab2fx "$outTab" > "$outFASTA"

