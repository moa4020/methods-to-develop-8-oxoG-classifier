#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J splitGTF_v04
#SBATCH -p scu-gpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/splitGTF_v04_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/splitGTF_v04_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-gpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --gpus-per-task=1

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/extract_GTF/splitGTF_v02"
inFileName="modLib_trimmed_filtered_m45-M4000_seqkit.locate_v02.gtf"
pyScriptDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/extract_GTF"


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

while read -r uniqueID; do
    gtfFile="${outDir}/${uniqueID}.gtf"
    if [[ ! -f "$gtfFile" ]]; then
        python "${pyScriptDir}/extract_GTF.py" "$sortedFilePath" "$uniqueID" "$gtfFile"
    else
        echo "Skipping ${uniqueID}.gtf as it already exists."
    fi
done < "$uniqueReadsFilePath"
