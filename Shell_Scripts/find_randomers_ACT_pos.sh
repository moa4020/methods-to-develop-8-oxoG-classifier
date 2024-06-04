#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J find_randomers_ACT_pos
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/find_randomers_ACT_pos_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/find_randomers_ACT_pos_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/ACT_Focus"

# Define file locations
RandomerIndex="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/Randomer_ACT_G.Ref_Index.tab"
Reads="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_indexed.tab"

# Copy files with error checking
if cp "$RandomerIndex" . && cp "$Reads" . ; then
    echo "Files copied successfully."
else
    echo "Error: Unable to copy files. Exiting."
    exit 1
fi

RandomerIndex="Randomer_ACT_G.Ref_Index.tab"
Reads="v02.2_trimmed_aligned_moves_indexed.tab"

# Initialize MappedRowStrings variable
MappedRowStrings=""

while IFS=$'\t' read -r _ _ sequence _; do
    echo "Looking for $sequence"
    MappedReads=$(grep "$sequence" "$Reads")
    MappedRows=$(echo "$MappedReads" | cut -f1)

    # Concatenate rows from MappedRows into one string separated by commas
    MappedRowString=$(echo "$MappedRows" | paste -sd ',' -)

    # If MappedRowString is empty, set it to "NA"
    if [ -z "$MappedRowString" ]; then
        MappedRowString="NA"
    fi

    echo "Found in rows: $MappedRowString"

    # Add MappedRowString as a row to MappedRowStrings
    MappedRowStrings+="$MappedRowString"$'\n'
done < "$RandomerIndex"

echo -e "$MappedRowStrings" > MappedRowStrings_pos.txt

paste "$RandomerIndex" MappedRowStrings_pos.txt > RandomerIndex_MappedPos_ACT.tab
