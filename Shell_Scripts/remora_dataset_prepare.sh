#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J remora_dataset_prepare
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/remora_dataset_prepare_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/remora_dataset_prepare_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=2

remora="/home/fs01/moa4020/miniforge3/bin/remora"

pod5Dir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2_Corrected/20240309_1530_MN44922_FAY08556_8d3f01dc/pod5_pass/merged"

bamDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/remora/v02.2"

cd $outDir

rm -rf controlchunks modchunks

$remora dataset prepare $pod5Dir/merged.pod5 $bamDir/v02.2_trimmed_aligned_moves.bam --output-path $outDir/controlchunks --refine-kmer-level-table $outDir/9mer_levels_v2.2.txt --refine-rough-rescale --motif TNNNNGNNNNG 5 --mod-base-control --num-extract-chunks-workers 2

$remora dataset prepare $pod5Dir/merged.pod5 $bamDir/v02.2_trimmed_aligned_moves.bam --output-path $outDir/modchunks --refine-kmer-level-table $outDir/9mer_levels_v2.2.txt --refine-rough-rescale --motif CNNNNGNNNNT 5 --mod-base o 8oxoG --num-extract-chunks-workers 2
