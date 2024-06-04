#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J dorado_basecall_m20
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/dorado_basecall_m20_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/dorado_basecall_m20_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=1

slow5dorado="/home/fs01/moa4020/slow5-dorado/bin"

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/blow5"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/alignment"

${slow5dorado}/slow5-dorado basecaller ${slow5dorado}/dna_r10.4.1_e8.2_400bps_sup@v4.1.0 ${inDir}/ --emit-moves > ${outDir}/m20_basecalls.sam
