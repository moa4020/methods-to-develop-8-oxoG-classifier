#!/bin/bash

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J seqkit_locate_randomers_pts12
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/seqkit_locate_randomers_pts12_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/seqkit_locate_randomers_pts12_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

seqkit="/home/fs01/moa4020/miniforge3/envs/seqkit/bin/seqkit"

# Change directory to the location of the sequence files
cd "/athena/cayuga_0003/scratch/moa4020/8-oxoG/randomerPositionMapping/seqkit_locate"

# Define the path to the fasta file
fa="/athena/cayuga_0003/scratch/moa4020/8-oxoG/basecalls/v02_dorado/v02.2_trimmed_aligned_moves_pts12.fasta"

# Locate sequences with specific patterns and output to separate files

# Original patterns
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNGNNNNTTACTTCGCGATCG -d -P > seqkit_locate_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNGNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_neg_pts12.tab
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNHNNNNTTACTTCGCGATCG -d -P > seqkit_locate_ACT_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNHNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_ACT_neg_pts12.tab

# Call 1 Insertion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNNNNNTTACTTCGCGATCG -d -P > seqkit_locate_insN_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_insN_neg_pts12.tab

# Call Left Insertion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNNGNNNNTTACTTCGCGATCG -d -P > seqkit_locate_insleftG_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNNGNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_insleftG_neg_pts12.tab
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNNHNNNNTTACTTCGCGATCG -d -P > seqkit_locate_insleftACT_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNNHNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_insleftACT_neg_pts12.tab

# Call Right Insertion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNGNNNNNTTACTTCGCGATCG -d -P > seqkit_locate_insrightG_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNGNNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_insrightG_neg_pts12.tab
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNHNNNNNTTACTTCGCGATCG -d -P > seqkit_locate_insrightACT_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNHNNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_insrightACT_neg_pts12.tab

# Call 1 Deletion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNNNNNTTACTTCGCGATCG -d -P > seqkit_locate_delN_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_delN_neg_pts12.tab

# Call Left Deletion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNGNNNNTTACTTCGCGATCG -d -P > seqkit_locate_delleftG_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNGNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_delleftG_neg_pts12.tab
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNHNNNNTTACTTCGCGATCG -d -P > seqkit_locate_delleftACT_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNHNNNNGCGTAATGGTTCAG -d -P > seqkit_locate_delleftACT_neg_pts12.tab

# Call Right Deletion
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNGNNNTTACTTCGCGATCG -d -P > seqkit_locate_delrightG_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNGNNNGCGTAATGGTTCAG -d -P > seqkit_locate_delrightG_neg_pts12.tab
cat "${fa}" | $seqkit locate -p GTAGTACACTGCCACNNNNHNNNTTACTTCGCGATCG -d -P > seqkit_locate_delrightACT_pos_pts12.tab
cat "${fa}" | $seqkit locate -p CAGTCACGAGTACTNNNNHNNNGCGTAATGGTTCAG -d -P > seqkit_locate_delrightACT_neg_pts12.tab

