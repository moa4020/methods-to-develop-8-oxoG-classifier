#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_fish_flanks
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_fish_flanks_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_fish_handles_%j.tab
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

cd /athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_fish

# Define the path to the fasta file
fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_pts12.fasta"

# Define query sequence fasta file
qfa="flankRef.fasta"

# Define bam file to save alignments
bam="seqkit_fish_handles.bam"

# Fish sequences with specific patterns and output to separate files

$seqkit fish -a -q 10 -f ${qfa} -g ${fa} -b ${bam} -s

