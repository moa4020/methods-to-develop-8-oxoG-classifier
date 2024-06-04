#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J remora_dataset_prepare_test
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/remora_dataset_prepare_test_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/remora_dataset_prepare_test_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=1
source /home/fs01/moa4020/myenv/bin/activate

remora="/home/fs01/moa4020/myenv/bin/remora"

pod5Dir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02/pod5_pass/merged"

bamDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/remora/v02/test"

cd $outDir

rm -rf controlchunks modchunks

$remora dataset prepare $pod5Dir/merged.pod5 $bamDir/v02_trimmed_aligned_moves_test.bam --output-path $outDir/controlchunks --refine-kmer-level-table $outDir/9mer_levels_v1.txt --refine-rough-rescale --motif CTNNNNGNNNNG 6 --mod-base-control --basecall-anchor --skip-shuffle

$remora dataset prepare $pod5Dir/merged.pod5 $bamDir/v02_trimmed_aligned_moves_test.bam --output-path $outDir/modchunks --refine-kmer-level-table $outDir/9mer_levels_v1.txt --refine-rough-rescale --motif CACNNNNGNNNN 7 --mod-base o 8oxoG --basecall-anchor --skip-shuffle
