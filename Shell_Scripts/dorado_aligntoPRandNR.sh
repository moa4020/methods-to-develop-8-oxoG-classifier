#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J dorado_aligntoPRandNR
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/dorado_aligntoPRandNR_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/dorado_aligntoPRandNR_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=4

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02/pod5_pass"

refPR="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/IntendedSequenceTop_PR_143x101.fasta"
refNR="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/IntendedSequenceTop_NR_143x101.fasta"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

$dorado/dorado basecaller $dorado/dna_r9.4.1_e8_sup@v3.6 $inputDir/ --reference $refPR --emit-moves --trim > $outDir/v02_trimmed_PRaligned_moves.bam

$dorado/dorado basecaller $dorado/dna_r9.4.1_e8_sup@v3.6 $inputDir/ --reference $refNR --emit-moves --trim > $outDir/v02_trimmed_NRaligned_moves.bam

