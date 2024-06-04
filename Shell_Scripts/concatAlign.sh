#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J concatAlign
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/concatAlign_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/concatAlign_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=12

dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.1-linux-x64/bin"

inputDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/modified"

outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/aligned.bam/mod"

refDir="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref"

${dorado}/dorado aligner ${refDir}/oligoConcat_DNACS_ref.fasta ${inputDir}/dsConcat_modLib_with_moves_trimmed.fq  > ${outDir}/mod_trimmed_aligned.bam
