#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_locate_randomers_m2
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_locate_randomers_m2_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/seqkit_locate_randomers_m2_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=16

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate_mismatch"

fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_pt2.fasta"

refDir="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref"

pos_ref=${refDir}/PosRandomers.fasta
neg_ref=${refDir}/NegRandomers.fasta
pos_ref_ACT=${refDir}/PosRandomersACT.fasta
neg_ref_ACT=${refDir}/NegRandomersACT.fasta


cat ${fa} | $seqkit locate -f $pos_ref -m 2 -F  -j 16 > seqkit_locate_m2_pos_pt2.tab

cat ${fa} | $seqkit locate -f $neg_ref -m 2 -F  -j 16 > seqkit_locate_m2_neg_pt2.tab
