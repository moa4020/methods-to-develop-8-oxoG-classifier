#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J mapComponents_Oligov02
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/mapComponents_Oligov02_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/mapComponents_Oligov02_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=10

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin"

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/fasta/v02"
#fastaName="FAW63250_pass_a05eaccd_244c1f4d_comb_idtrim.fasta"
fastaName="FAW63250_comb_trimmed.fasta"
refDir="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/v02/test1"

# Define an array of file names
files=("NegativeRandomerLeftHandle.fasta" "NegativeRandomerRightHandle.fasta" "PositiveRandomerLeftHandle.fasta" "PositiveRandomerRightHandle.fasta" "P3N5_Top.fasta" "N3P5_Top.fasta" "P3N5_Bottom.fasta" "N3P5_v02_Bottom.fasta")

# Iterate through the files
for file in "${files[@]}"; do
    refName=${refDir}/${file}
    # Calculate the -m value based on the length of the sequence
    sed '2!d' ${refName} | wc -c > seqLength
    mValue=$(( (seqLength + 9) / 10 )) 
    # Construct the output file path
    outFile="${outDir}/$(basename ${fastaName} .fasta)_seqkit.locate_$(basename ${file} .fasta).gtf"
    # Run the command
    cat ${inDir}/${fastaName} | ${seqkit}/seqkit -j 10 locate -f ${refName} -m ${mValue} --gtf -I -P -F > ${outFile}
done
