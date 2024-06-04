#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J motifSearch
##SBATCH -J etest
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/motifSearch_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/motifSearch_%j.out
#SBATCH -t 72:00:00
#SBATCH --mem-per-cpu=93G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=8

fasta="/athena/cayuga_0003/scratch/moa4020/8-oxoG/fasta/dsConcat/withEndPrep/dsCon_wEndPrep_trim_filtered.fasta"

bbmap="/athena/cayuga_0003/scratch/moa4020/bbmap"

outputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch"

# Extract file name without extension
fileName=$(basename "$fasta" .fasta)

# Run bbduk.sh
$bbmap/bbduk.sh in="$fasta" outm="$outputDir/${fileName}_matched.fasta" literal="TACCACAAACNNNNNNGNNNNNNACCTCACACTGT" k=35 hdist=2 edist=2 copyundefined minlength=35 maxlength=2000 maskmiddle=f threads=8 -Xmx700g
