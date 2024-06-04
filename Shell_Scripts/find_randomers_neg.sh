#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J find_randomers_neg
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/find_randomers_neg_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/find_randomers_neg_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/G_Focus"

# Define file locations
RandomerIndex="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/RandomerIndex.tab"
Reads="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_indexed.tab"

cp $RandomerIndex .
cp $Reads .

RandomerIndex="RandomerIndex.tab"
Reads="v02.2_trimmed_aligned_moves_indexed.tab"

# Initialize MappedRowStrings variable
MappedRowStrings=""

while IFS=$'\t' read -r _ sequence _; do
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

echo -e "$MappedRowStrings" > MappedRowStrings_neg.txt

paste "$RandomerIndex" MappedRowStrings_neg.txt > RandomerIndex_MappedNeg.tab

