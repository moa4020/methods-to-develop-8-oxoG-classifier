#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J hiruna_run
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/hiruna_run_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/hiruna_run_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=16

# ReadME first!!!
# This is a long pipeline and might not work in the first go.
# Go all the way to the bottom and uncomment functions one by one, run and make sure all the commands work before moving to the next function.
# Details of the variables and functions can be found at #https://github.com/hiruna72/squigualiser/blob/main/docs/pipeline_basic.md
# Good luck!

info() { echo -e "\n\033[0;32m$1\033[0m" >&2; }
info "$(date)"

RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m' # No Color

# Set variables
RUN_NO="RUN01"
MODEL="dna_r10.4.1_e8.2_400bps_sup@v4.3.0"
HOME="/home/fs01/moa4020"
ENVS="$HOME/miniforge3/envs"
SQUIGULATOR="$HOME/squigulator-v0.3.0/squigulator"
SLOW5TOOLS="$ENVS/slow5tools/bin/slow5tools"
SAMTOOLS="$ENVS/samtools/bin/samtools"
MINIMAP2="$ENVS/minimap2/bin/minimap2"
DORADO="/athena/cayuga_0003/scratch/moa4020/dorado-0.5.3-linux-x64/bin"
SQUIG="$HOME/squigualiser/squig_venv/bin/squigualiser"
source "$HOME/squigualiser/squig_venv/bin/activate"
REFERENCE="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/m20_randomer_reference_padded.fasta"
CHUNK_SIZE="--chunksize 2000"
SIMULATING_PROFILE="dna-r10-prom"
RE_REFORM_K=2
RE_REFORM_M=1
PROFILE_TO_DETERMINE_BASE_SHIFT="kmer_model_dna_r10.4.1_e8.2_400bps_9_mer"
REF_REGION="TTATGATTA_NR:801-906"
SIM_REGION="sim_ref:1-105"
SIG_SCALE="--sig_scale znorm"
IN_DIR="/athena/cayuga_0003/scratch/moa4020/8-oxoG/squig"
cd "$IN_DIR"
MOVES_BAM="$IN_DIR/m20_filtered_aligned_sorted.bam"
SEQUENCE_FILE="$IN_DIR/m20_filtered.fastq"
SIGNAL_FILE="$IN_DIR/m20_merged.slow5"
OUTPUT_DIR="${IN_DIR}/OUT"
SIMULATE_READ_DIR="$OUTPUT_DIR/simulate_read"
SIMULATE_REF_DIR="$OUTPUT_DIR/simulate_ref"
SQUIG_PLOT_DIR="$OUTPUT_DIR/squig_plot_reads"
REFORMAT_PAF="$OUTPUT_DIR/reform.paf"
RE_REFORMAT_PAF="$OUTPUT_DIR/re_reform.paf"
MAPPED_BAM="$OUTPUT_DIR/mapped.bam"
REALIGN_BAM="$OUTPUT_DIR/realigned.bam"

# Run commands
info "running reform..."
"$SQUIG" reform -k 1 -m 0 --bam "$MOVES_BAM" -c -o "$REFORMAT_PAF"

info "calculating offsets..."
"$SQUIG" calculate_offsets -p "$REFORMAT_PAF" -f "$SEQUENCE_FILE" -s "$SIGNAL_FILE"

info "running re-reform..."
"$SQUIG" reform -k $RE_REFORM_K -m $RE_REFORM_M --bam "$MOVES_BAM" -c -o "$RE_REFORMAT_PAF"

mkdir -p "$SQUIG_PLOT_DIR"
"$SQUIG" plot -f "$SEQUENCE_FILE" -s "$SIGNAL_FILE" -a "$REFORMAT_PAF" --plot_limit 50 -o "$SQUIG_PLOT_DIR/reads"

info "aligning reads using minimap2..."
"$MINIMAP2" -ax map-ont "$REFERENCE" -t16 --secondary=no "$SEQUENCE_FILE" | "$SAMTOOLS" sort -o "$MAPPED_BAM"
"$SAMTOOLS" index "$MAPPED_BAM"

info "re-aligning cigar mapping to moves..."
"$SQUIG" realign --bam "$MAPPED_BAM" --paf "$RE_REFORMAT_PAF" -o "$REALIGN_BAM"
"$SAMTOOLS" index "$REALIGN_BAM"

info "simulating using $SIMULATING_PROFILE"
"$SIMULATE_REF_DIR" && rm -r "$SIMULATE_REF_DIR"
mkdir "$SIMULATE_REF_DIR"

REGION_FILE="$SIMULATE_REF_DIR/region.file"
echo "$REF_REGION" > "$REGION_FILE"
"$SAMTOOLS" faidx "$REFERENCE" --region-file "$REGION_FILE" -o "$SIMULATE_REF_DIR/ref.fasta"
sed -i "1s/.*/>sim_ref/" "$SIMULATE_REF_DIR/ref.fasta"

"$SQUIGULATOR" --seed 1 --full-contigs --ideal-time --amp-noise 0 -x "$SIMULATING_PROFILE" "$SIMULATE_REF_DIR/ref.fasta" -o "$SIMULATE_REF_DIR/sim.slow5" -c "$SIMULATE_REF_DIR/sim.paf" -a "$SIMULATE_REF_DIR/sim.sam" -q "$SIMULATE_REF_DIR/sim.fasta"
"$SAMTOOLS" sort "$SIMULATE_REF_DIR/sim.sam" -o "$SIMULATE_REF_DIR/sim.bam"
"$SAMTOOLS" index "$SIMULATE_REF_DIR/sim.bam"

mkdir -p "$SQUIG_PLOT_DIR"

TRACK_COMMAND_FILE="$SQUIG_PLOT_DIR/track_commands_${FUNCNAME[0]}.txt"
rm -f "$TRACK_COMMAND_FILE"
echo "num_commands=2" > "$TRACK_COMMAND_FILE"
echo "plot_heights=*" >> "$TRACK_COMMAND_FILE"
echo "$SQUIG" plot_pileup -f "$REFERENCE" -s "$SIGNAL_FILE" -a "$REALIGN_BAM" --region "$REF_REGION" --tag_name Method:realign --plot_limit 6 "$SIG_SCALE" >> "$TRACK_COMMAND_FILE"
echo "$SQUIG" plot_pileup -f "$SIMULATE_REF_DIR/ref.fasta" -s "$SIMULATE_REF_DIR/sim.slow5" -a "$SIMULATE_REF_DIR/sim.bam" --region "$SIM_REGION" --tag_name "${MODEL_TO_USE}_sim_read" --no_overlap --profile "$PROFILE_TO_DETERMINE_BASE_SHIFT" >> "$TRACK_COMMAND_FILE"

"$SQUIG" plot_tracks --shared_x -f "$TRACK_COMMAND_FILE" -o "$SQUIG_PLOT_DIR/${MODEL_TO_USE}_realigned_vs_sim" --tag_name "${MODEL_TO_USE}_realigned_vs_sim"

info "success"

