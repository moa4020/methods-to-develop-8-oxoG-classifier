#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J splitGTF_v05_cpu
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/splitGTF_v05_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/splitGTF_v05_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

inDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/sampleGTF"
outDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/sampleGTF/readwiseGTF"
pyScriptDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/modified/extract_GTF"

for x in {1..10}; do 
    inFileName="modLib_trimmed_filtered_m45-M4000_seqkit.locate_v02_0.03Sample${x}.gtf"
    
    # Check if uniqueReads.txt already exists
    uniqueReadsFilePath="$inDir/uniqueReads_v02_0.03sample_${x}.txt"
    
    if [ ! -e "$uniqueReadsFilePath" ]; then
        # Save unique read names in a list
        cut -f1 -d$'\t' "$inDir/$inFileName" | uniq > "$uniqueReadsFilePath"
    fi
    
    while read -r uniqueID; do
        gtfFile="${outDir}/${uniqueID}.gtf"
        
        if [[ ! -s "$gtfFile" ]]; then
            python "${pyScriptDir}/extract_GTF.py" "$inDir/$inFileName" "$uniqueID" "$gtfFile"
            
            # Sort the file based on the start position of the feature
            sort -k3,3 -o "$gtfFile" "$gtfFile"
        else
            echo "Skipping ${uniqueID}.gtf as it already exists or is empty."
        fi
    done < "$uniqueReadsFilePath"
done
