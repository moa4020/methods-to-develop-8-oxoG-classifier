#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J hiruna_run_dorado
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/hiruna_run_dorado_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/hiruna_run_dorado_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=240G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=4

MODEL="dna_r10.4.1_e8.2_400bps_sup@v4.3.0"
HOME="/home/fs01/moa4020"
ENVS=${HOME}/miniforge3/envs
SAMTOOLS=${ENVS}/samtools/bin/samtools
DORADO="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

pod5Dir=/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/m20randomer_pod5
outDir=/athena/cayuga_0003/scratch/moa4020/8-oxoG/alignment
moves_bam=${outDir}/m20_filt_moves.bam
fastq=${outDir}/m20_filt_moves.fastq

${DORADO}/dorado basecaller ${DORADO}/${MODEL} --emit-moves ${pod5Dir} > ${moves_bam}

${SAMTOOLS} fastq ${moves_bam} > ${fastq}
