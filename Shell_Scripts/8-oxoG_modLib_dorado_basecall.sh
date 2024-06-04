#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J 8-oxoG_modLib_dorado_basecall
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/8-oxoG_modLib_dorado_basecall_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/8-oxoG_modLib_dorado_basecall_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=1

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/Mohith_dsConcat_8-oxoG/8-oxoG_ModLib_dsConcat/pod5"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/modified"

$dorado/dorado basecaller $dorado/dna_r10.4.1_e8.2_400bps_sup@v4.3.0 $inputDir/ --emit-moves --emit-fastq > $outDir/dsConcat_modLib_with_moves.fastq

