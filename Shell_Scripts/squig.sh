#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J squig
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/squig_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/squig_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=12

samtools="/home/fs01/moa4020/miniforge3/envs/samtools/bin/samtools"
minimap2=/home/fs01/moa4020/miniforge3/envs/minimap2/bin/minimap2
squigualiser="/home/fs01/moa4020/squigualiser/squig_venv/bin"
#dorado="/athena/cayuga_0003/scratch/moa4020/dorado-0.6.1-linux-x64/bin"

samFile="/athena/cayuga_0003/scratch/moa4020/8-oxoG/alignment/m20_filt_moves_sort.bam"
fastq="/athena/cayuga_0003/scratch/moa4020/8-oxoG/alignment/m20_filt_moves.fastq"
blow5Dir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/blow5"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/squig/OUT"

slow5="/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/m20randomer_pod5/m20_filtered_fast5/slow5/m20_merged.slow5"

source ${squigualiser}/activate

ALIGNMENT=reform_output.paf
REF=/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/m20_randomer_reference_padded.fasta
MAPP_SAM=mapped_m20_basecalls.sam
REGION=TTATGATTA_NR:801-905
SIGNAL_FILE=/athena/cayuga_0003/scratch/moa4020/8-oxoG/rawdata/v02.2/pod5_pts12/m20randomer_pod5/m20_filtered_fast5/slow5/m20_merged.slow5

cd ${outDir}

# Step 0: Add a fake SQ tag
echo -e fake_reference'\t'0 > ${outDir}/fake_reference.fa.fai
#${samtools} view ${samFile} -h -t ${outDir}/fake_reference.fa.fai -o ${outDir}/sq_added_m20_basecalls.sam

# Step 1: Reformat
#${squigualiser}/squigualiser reform --sig_move_offset 0 --kmer_length 1 -c --bam ${samFile} -o ${outDir}/${ALIGNMENT}

# Step 2: Alignment
#${minimap2} -a -B 8 -O 4,28 -t12 --secondary=no -o ${MAPP_SAM} ${REF} ${fastq}

# Step 3: Realign reformatted file based on alignment from step 2.2
REALIGN_BAM=realign_m20_basecalls.bam
#${squigualiser}/squigualiser realign --bam ${MAPP_SAM} --paf ${ALIGNMENT} -o ${REALIGN_BAM}

#${samtools} sort ${REALIGN_BAM} > sorted_realigned_m20.bam
#${samtools} index sorted_realigned_m20.bam

OUTPUT_DIR=output_dir

# Step 4: Plot squiggles in a specific region
#${squigualiser}/squigualiser plot --file ${REF} --slow5 ${SIGNAL_FILE} --alignment sorted_realigned_m20.bam --output_dir ${OUTPUT_DIR} --region ${REGION} --tag_name "optionA"

${squigualiser}/squigualiser plot_pileup --file ${REF} --slow5 ${SIGNAL_FILE} --alignment sorted_realigned_m20.bam --output_dir output_dir --region ${REGION} --tag_name "pileup"
