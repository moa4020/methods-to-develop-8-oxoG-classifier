#!/bin/bash -l
 
#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J 8-oxoG_control_skipEndPrep-dorado_basecall
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/8-oxoG_control_skipEndPrep-dorado_basecall_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/8-oxoG_control_skipEndPrep-dorado_basecall_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=1

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.0-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/dsConcat/skipEndPrep/pod5"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/dsConcat/skipEndPrep"

$dorado/dorado basecaller $dorado/dna_r9.4.1_e8_sup@v3.6 $inputDir/ --no-trim > $outDir/dsConcat_skipEndPrep.bam

$dorado/dorado trim $outDir/dsConcat_skipEndPrep.bam > $outDir/dsConcat_skipEndPrep_trimmed.bam
