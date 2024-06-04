#!/bin/bash -l
 
#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J remora_infer
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/remora_infer_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/remora_infer_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=2
 
remora="/home/fs01/moa4020/miniforge3/bin"
 
workingDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/remora/v02.2"

pod5="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2_Corrected/20240309_1530_MN44922_FAY08556_8d3f01dc/pod5_pass/merged/merged.pod5"

bamDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado"
 
cd $workingDir

${remora}/remora \
  infer from_pod5_and_bam \
  $pod5\
  $bamDir/v02.2_trimmed_aligned_moves.bam \
  --model ${workingDir}/train_results/model_best.pt \
  --out-bam ${workingDir}/test_infer/test_infer.bam \
  --log-filename ${workingDir}/test_infer/test_infer.log \
  --device 0

