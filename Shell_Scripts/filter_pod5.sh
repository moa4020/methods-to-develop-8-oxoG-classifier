#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J filter_pod5
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/filter_pod5_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/filter_pod5_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

pod5tools=/home/fs01/moa4020/miniforge3/envs/pod5/bin

pod5Dir=/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12
out=/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/m20randomer_pod5
readIds=/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate_flanks/unique_m20ReadIds.txt

cd ${pod5Dir}

$pod5tools/pod5 filter *.pod5 --output m20randomer_pod5/m20_filtered.pod5 --ids ${readIds} --missing-ok

