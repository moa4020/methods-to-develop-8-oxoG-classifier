#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J remora_make_config 
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/remora_make_config_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/remora_make_config_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=2

remora="/home/fs01/moa4020/miniforge3/bin/remora"

workingDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/remora/v02.2"

cd $workingDir

$remora \
  dataset make_config \
  train_dataset.jsn \
  modchunks \
  --dataset-weights 1 1 \
  --log-filename train_dataset.log

