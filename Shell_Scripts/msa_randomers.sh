#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J msa_randomers
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/msa_randomers_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/msa_randomers_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=8

workingDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/leftRight/randomers"
clustalo="/home/fs01/moa4020/miniforge3/envs/clustalo/bin"

cd ${workingDir}

cat cLib_randomers.fasta | awk '/^>/{print ">" ++i; next}{print}' > cLib_randomers_proxy.fasta
cat mLib_randomers.fasta | awk '/^>/{print ">" ++i; next}{print}' > mLib_randomers_proxy.fasta
cat cSOLib_randomers.fasta | awk '/^>/{print ">" ++i; next}{print}' > cSOLib_randomers_proxy.fasta


${clustalo}/clustalo -i cLib_randomers_proxy.fasta -o cLib_randomers_proxy_cluso.fasta -v
${clustalo}/clustalo -i mLib_randomers_proxy.fasta -o mLib_randomers_proxy_cluso.fasta -v
${clustalo}/clustalo -i cSOLib_randomers_proxy.fasta -o cSOLib_randomers_proxy_cluso.fasta -v
