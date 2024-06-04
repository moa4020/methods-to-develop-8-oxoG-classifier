#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J dorado_aligntoNR
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/dorado_aligntoNR_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/dorado_aligntoNR_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=4

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02/pod5_pass"

ref="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/NR.fasta"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

$dorado/dorado basecaller $dorado/dna_r9.4.1_e8_sup@v3.6 $inputDir/ --reference $ref --emit-moves --trim > $outDir/v02_trimmed_NRaligned_moves.bam

