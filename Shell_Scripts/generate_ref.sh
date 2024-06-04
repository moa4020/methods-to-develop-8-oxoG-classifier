#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J generate_ref
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/generate_ref_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/generate_ref_%j.out
#SBATCH -t 72:00:00
#SBATCH --mem-per-cpu=400G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=1

python /athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degeneracy_left.py
python /athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degeneracy_right.py

python /athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/matrix_function.py
