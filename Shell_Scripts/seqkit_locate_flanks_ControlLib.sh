#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_locate_flanks_ControlLib
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_locate_flanks_ControlLib_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/seqkit_locate_flanks_ControlLib_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

# Change directory to the location of the sequence files
cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate_flanks"

# Define the path to the fasta file
fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02/FAW63250_comb_trimmed.fasta"

# Locate sequences with specific patterns and output to separate files

cat "${fa}" | $seqkit locate -f Pos_flank_Xmers.fasta -d -P > seqkit_locate_flanks_pos_CL.tab
cat "${fa}" | $seqkit locate -f Neg_flank_Xmers.fasta -d -P > seqkit_locate_flanks_neg_CL.tab

