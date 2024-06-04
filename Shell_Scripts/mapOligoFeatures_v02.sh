#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J mapOligoFeatures_v02
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/mapOligoFeatures_v02_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/mapOligoFeatures_v02_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=10

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin"

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/modified/seqkit_filtered_datasets"

#fastqName="modLib_trimmed_filtered_m45-M4000.fastq"
fastaName="modLib_trimmed_filtered_m45-M4000.fasta"

oligoDict="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/oligoDictionary_v02.fasta"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified"

cd ${inDir}

cat ${fastaName} | ${seqkit}/seqkit -j 10 locate -f ${oligoDict} -m 1 --gtf -I -P -F > ${outDir}/$(basename ${fastaName} .fasta)_seqkit.locate_v02.gtf
