#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J cluso
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/cluso_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/cluso_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=16

clustalo="/home/fs01/moa4020/miniforge3/envs/cluso/bin"
cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02"

$clustalo/clustalo -i v02Lib_randomers_NR.fasta -o v02Lib_randomers_NR_msa.fasta --force --threads=16
$clustalo/clustalo -i v02Lib_randomers_PR.fasta -o v02Lib_randomers_PR_msa.fasta --force --threads=16
