#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_locate_flanks
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_locate_flanks_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/seqkit_locate_flanks_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

cd /athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate_flanks

# Define the path to the fasta file
fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_pts12.fasta"

# Define query sequence fasta file
qfa="flankRef.fasta"

# Locate sequences with specific patterns and output to separate files

cat ${fa} | $seqkit locate -m 3 -p CAGTCACGAGTACT --bed -P -F > seqkit_fish_handles_NRLeft.bed
cat ${fa} | $seqkit locate -m 3 -p GCGTAATGGTTCAG --bed -P -F > seqkit_fish_handles_NRRight.bed

cat ${fa} | $seqkit locate -m 3 -p GTAGTACACTGCCAC --bed -P -F > seqkit_fish_handles_PRLeft.bed
cat ${fa} | $seqkit locate -m 5 -p TTACTTCGCGATCG--bed -P -F > seqkit_fish_handles_PRRight.bed
