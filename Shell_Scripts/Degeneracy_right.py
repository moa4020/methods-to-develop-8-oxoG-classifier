# -*- coding: utf-8 -*-
"""
Created on Sun Sep  5 00:25:37 2021

@author: Chamara Janaka Bandara
"Kindly Cite the code if you use this code or modification of this code, thanks!"

"Generate all the possible combinations of a Degenerate DNA/RNA sequence in FASTA format

Code is written to generate all the possible combinations of a degenerate DNA or RNA sequence in FASTA format. 
It requires degenerate positions in standard format “A, T, G, C, U, W, S, M, K, R, Y, B, D, H, V or N”. 
Ex: ATTGGGGCCCACAGGTANATGGAWTTGACASTTAGM 
"""

sequence = "NNNNNNACCTCACACTGT" # Insert the degenerate DNA/RNA sequence in the standard form here

code_file_c1 = open("/athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degenerate_sequences_right.fasta", "w")# Create a fasta file to save all the possible combinations for the degenerate DNA or RNA sequence
code_file_c1 = open("/athena/cayuga_0003/scratch/moa4020/8-oxoG/degenerateRef/Degenerate_sequences_right.fasta", "a") 

list_1 = [char for char in sequence] # First preceptrone layer
current_posi = 0
list_2 = [] # Second preceptrone layer with degeneracy values
while current_posi < len(list_1):
    if list_1[current_posi] == "A":
        list_2.append(1)
    if list_1[current_posi] == "T":
        list_2.append(1)
    if list_1[current_posi] == "G":
        list_2.append(1)
    if list_1[current_posi] == "C":
        list_2.append(1)
    if list_1[current_posi] == "U":
        list_2.append(1)
    if list_1[current_posi] == "W":
        list_2.append(2)
    if list_1[current_posi] == "S":
        list_2.append(2)
    if list_1[current_posi] == "M":
        list_2.append(2)
    if list_1[current_posi] == "K":
        list_2.append(2)
    if list_1[current_posi] == "R":
        list_2.append(2)
    if list_1[current_posi] == "Y":
        list_2.append(2)
    if list_1[current_posi] == "B":
        list_2.append(3)
    if list_1[current_posi] == "D":
        list_2.append(3)
    if list_1[current_posi] == "H":
        list_2.append(3)
    if list_1[current_posi] == "V":
        list_2.append(3)
    if list_1[current_posi] == "N":
        list_2.append(4)
    current_posi = current_posi + 1
 
# Determine total degenerate states    
current_posi_2 = 0
total_degeneracy = 1
while current_posi_2 < len(list_2): 
    if int(list_2[current_posi_2]) > 0:
        total_degeneracy = total_degeneracy * int(list_2[current_posi_2])
    current_posi_2 = current_posi_2 + 1
    
print("Total degeneracy: " + str(total_degeneracy))

if total_degeneracy <2:
    print("No degenerate states")
    raise SystemExit

# Degenerate assignments
# Apply all the degenerate assignments to the thired preceptrone layer
cu_posi = 0
while cu_posi < len(list_1):
    list_3 = list_1
    if list_1[cu_posi] == "W":
        list_3[cu_posi] = ["A","T"]
    if list_1[cu_posi] == "S":
        list_3[cu_posi] = ["C","G"]
    if list_1[cu_posi] == "M":
        list_3[cu_posi] = ["A","C"]
    if list_1[cu_posi] == "K":
        list_3[cu_posi] = ["G","T"]
    if list_1[cu_posi] == "R":
        list_3[cu_posi] = ["A","G"]
    if list_1[cu_posi] == "Y":
        list_3[cu_posi] = ["C","T"]
    if list_1[cu_posi] == "B":
        list_3[cu_posi] = ["C","G","T"]
    if list_1[cu_posi] == "D":
        list_3[cu_posi] = ["A","G","T"]
    if list_1[cu_posi] == "H":
        list_3[cu_posi] = ["A","C","T"]
    if list_1[cu_posi] == "V":
        list_3[cu_posi] = ["A","C","G"]
    if list_1[cu_posi] == "N":
        list_3[cu_posi] = ["A","C", "G","T"]
    cu_posi = cu_posi + 1

# Generate the Base sequence
cu_posi_1 = 0
list_4 = []
var_1 = 0
while cu_posi_1 < len(list_1):
    for i in range (len(list_2)):
        if var_1 == 0:
            if int(list_2[i]) > 1:
                list_4.append([item[0] for item in list_3[0:]])
                var_1 = var_1 + 1
    cu_posi_1 =cu_posi_1 + 1
list_4 = list_4[0] 

# Generate each degenrate sequence
list_6 = []
text_1 = ''.join([str(elem) for elem in list_4])
list_6.append([char for char in text_1])
for base_1 in range (len(list_3)):
    if int(list_2[base_1]) > 1:
        for branch_1 in range (len(list_3[base_1])):
            if int(branch_1) > 0:
                for length_list_6 in range (len(list_6)):
                    var_1 = str(list_3[base_1][branch_1])
                    text_2 = ''.join([str(elem) for elem in list_6[length_list_6]])
                    list_var =[char for char in text_2]
                    list_var[base_1] = var_1
                    list_6.append([list[0] for list in list_var])
list_7 = []
for len_list_6 in range (len(list_6)):
    text_3 = ''.join([str(elem) for elem in list_6[len_list_6]])
    list_7.append(text_3)
    
# Filter some of the duplicates formed and write to the file in the 'fasta' format
list_8 =[]
list_8 = list(dict.fromkeys(list_7)) 
for len_list_7 in range (len(list_8)):
    text_4 = ''.join([str(elem) for elem in list_8[len_list_7]])
    code_file_c1.write(">degenrate_right" + str(int(len_list_7) + 1) + "\n" + text_4 + "\n") # Write all the degenerate sequences to the fasta file (Degenerate_sequences.fasta) 
code_file_c1.close()
print("Finished")   



        
