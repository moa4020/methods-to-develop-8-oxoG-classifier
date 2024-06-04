#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J dorado_basecall
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/dorado_basecall_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/dorado_basecall_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=2

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02/test1/20240225_0256_MC-111580_FAW63250_a05eaccd/pod5_pass/pod5files"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

$dorado/dorado basecaller $dorado/dna_r9.4.1_e8_sup@v3.6 $inputDir/ --emit-moves --emit-fastq > $outDir/dsConcat_withEndPrep_with_moves.fastq

