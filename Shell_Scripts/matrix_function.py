# Function to read sequences and headers from a FASTA file
def read_fasta_sequences(file_path):
    sequences = []
    with open(file_path, "r") as file:
        lines = file.readlines()
        header = ""
        sequence = ""
        for line in lines:
            if line.startswith(">"):
                if header != "":
                    sequences.append((header, sequence))
                header = line.strip()
                sequence = ""
            else:
                sequence += line.strip()
        sequences.append((header, sequence))
    return sequences

# Function to generate sequences based on right motif and write to files
def generate_and_write_sequences(left_sequences, right_sequences, output_folder):
    right_motifs = [right_seq for _, right_seq in right_sequences]
    for col_index, (left_header, left_sequence) in enumerate(left_sequences):
        combined_header = f">combination_{col_index}_{left_header}"
        combined_sequences = [left_sequence + right_motif for right_motif in right_motifs]
        
        # Write all combined sequences to a single file for each left sequence
        file_path = f"{output_folder}/combination_{col_index}.fasta"
        with open(file_path, "w") as file:
            for index, combined_sequence in enumerate(combined_sequences):
                file.write(f"{combined_header}_{index}\n{combined_sequence}\n")

# Paths to the left and right sequence files
left_file_path = "/athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degenerate_sequences_left.fasta"
right_file_path = "/athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degenerate_sequences_right.fasta"

# Read sequences and headers from the left and right files
left_sequences = read_fasta_sequences(left_file_path)
right_sequences = read_fasta_sequences(right_file_path)

# Specify the output folder for combination files
output_folder = "/athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef"

# Generate sequences based on right motif and write to files
generate_and_write_sequences(left_sequences, right_sequences, output_folder)

print("Finished")
