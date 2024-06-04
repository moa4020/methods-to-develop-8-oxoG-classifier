#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J find_randomers
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/find_randomers_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/find_randomers_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/G_Focus"

# Define file locations
RandomerIndex="/athena/cayuga_0003/scratch/moa4020/refDir/8-oxoG_ref/RandomerIndex.tab"
Reads="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_indexed.tab"

cp "$RandomerIndex" .
cp "$Reads" .

RandomerIndex="RandomerIndex.tab"
Reads="v02.2_trimmed_aligned_moves_indexed.tab"

# Function to find mapped rows
find_mapped_rows() {
    local input_file="$1"
    local reads_file="$2"
    local output_file="$3"
    local column="$4"
    
    # Use awk to search for sequence and extract mapped rows
    awk -v column="$column" -v reads_file="$reads_file" -v output_file="$output_file" '
        BEGIN { FS = "\t" }
        NR == FNR { sequences[$1]; next }
        {
            for (seq in sequences) {
                if ($column == seq) {
                    print "Looking for " $column >> "/athena/cayuga_0003/scratch/moa4020/scripts/out/find_randomers_%j.out"
                    print "Found in rows: " $1 >> output_file
                    break
                }
            }
        }
    ' "$input_file" "$reads_file"
}

export -f find_mapped_rows

# Run the function for RandomerIndex column 2 (Neg)
find_mapped_rows "$RandomerIndex" "$Reads" "RandomerIndex_MappedNeg.tab" 1

# Run the function for RandomerIndex column 3 (Pos)
find_mapped_rows "$RandomerIndex" "$Reads" "RandomerIndex_MappedPos.tab" 2

# Notify user when the process is complete
echo "Process is complete. Output files have been saved." >> /athena/cayuga_0003/scratch/moa4020/scripts/out/find_randomers_%j.out

