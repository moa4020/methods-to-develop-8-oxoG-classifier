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

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2_Corrected/20240309_1530_MN44922_FAY08556_8d3f01dc/pod5_pass"

refDir="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

$dorado/dorado basecaller $dorado/dna_r10.4.1_e8.2_400bps_sup@v4.3.0 $inputDir/ --reference $refDir/IntendedSequenceTop_143x1326.fasta --emit-moves --trim > $outDir/v02.2_trimmed_aligned_moves.bam
