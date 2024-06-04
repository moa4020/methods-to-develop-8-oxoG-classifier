#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J splitGTF
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/splitGTF_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/splitGTF_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=100G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=1

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/readwiseGTF"
inFileName="modLib_trimmed_filtered_m45-M4000_seqkit.locate_v03.gtf"

# Check if the sorted file already exists
sortedFilePath="$inDir/$(basename "$inDir/$inFileName" .gtf)_sorted.gtf"
if [ ! -e "$sortedFilePath" ]; then
  # Sort the GTF file based on the first column
  sort -k1,1 "$inDir/$inFileName" > "$sortedFilePath"
fi

# Check if uniqueReads.txt already exists
uniqueReadsFilePath="$inDir/uniqueReads.txt"

if [ ! -e "$uniqueReadsFilePath" ]; then
  # Save unique read names in a list
  cut -f1 -d$'\t' "$sortedFilePath" | uniq > "$uniqueReadsFilePath"
fi

flag=0

while read -r uniqueID; do
  awk -v uid="$uniqueID" 'BEGIN { flag = 0; } $1 == uid {if (flag == 0) {current_lines = $0; flag = 1;} else {current_lines = current_lines ORS $0;} next;} flag == 1 {print current_lines > "'"$outDir/$uniqueID.gtf"'"; flag = 0;}' "$sortedFilePath"

  if [ "$flag" -eq 1 ]; then
    echo -e "$current_lines" > "$outDir/$uniqueID.gtf"
  fi
done < "$uniqueReadsFilePath"

