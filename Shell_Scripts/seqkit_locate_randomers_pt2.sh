#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_locate_randomers_pt2
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_locate_randomers_pt2_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/seqkit_locate_randomers_pt2_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate"

fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_pt2.fasta"

cat ${fa} | $seqkit locate -p GTAGTACACTGCCACNNNNGNNNNTTACTTCGCGATCG -d -P > seqkit_locate_pos_pt2.tab

cat ${fa} | $seqkit locate -p CAGTCACGAGTACTNNNNGNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_neg_pt2.tab

cat ${fa} | $seqkit locate -p GTAGTACACTGCCACNNNNHNNNNTTACTTCGCGATCG -d -P > seqkit_locate_ACT_pos_pt2.tab

cat ${fa} | $seqkit locate -p CAGTCACGAGTACTNNNNHNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_ACT_neg_pt2.tab

