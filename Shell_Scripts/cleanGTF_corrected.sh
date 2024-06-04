#!/bin/bash -l

#SBATCH --mail-user=moa4020@med.cornell.edu
#SBATCH --mail-type=ALL
#SBATCH -J cleanGTF_corrected
#SBATCH -p scu-cpu
#SBATCH -e /athena/cayuga_0003/scratch/moa4020/scripts/err/cleanGTF_corrected_%j.err
#SBATCH -o /athena/cayuga_0003/scratch/moa4020/scripts/out/cleanGTF_corrected_%j.out
#SBATCH -t 7-00:00:00
#SBATCH --mem-per-cpu=80G
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

workingDir="/athena/cayuga_0003/scratch/moa4020/8-oxoG/motifsearch/control/corrected"
inputFile="corrected_merged.gtf"
cutFile="corrected_tr_flt_seqkit.loc.merge.cut.tsv"
sortedFile="corrected_tr_flt_seqkit.loc.merge.cut.sorted.tsv"
filteredFile="corrected_tr_flt_seqkit.loc.merge.cut.sorted.filtered.tsv"
combinedFile="corrected_tr_flt_seqkit.loc.merge.cut.sorted.flt.col234Combined.tsv"
appendedFile="corrected_tr_flt_seqkit.loc.merge.cut.sort.flt.comb.append.tsv"

cd ${workingDir}

#Isolate columns of interest
cut -d $'\t' -f 1,4,5,9 ${inputFile} > ${cutFile}

#Remove the first part of the gene_id format
sed 's/gene_id "//g' ${cutFile} > corrected.tsv && mv corrected.tsv ${cutFile}

#Remove the latter part of the gene_id format 
sed 's/";//g' ${cutFile} > corrected.tsv && mv corrected.tsv ${cutFile}

#Sort the rows based on column 1 - read name and column 2 - coordinate 1 (numerical value)
sort -k1,1 -k2,2n ${cutFile} > ${sortedFile}

#Find sequences with more than one recognizable motif
awk 'NR==FNR{count[$1]++; next} count[$1]>1' ${sortedFile} ${sortedFile} > ${filteredFile}

#Combine coordinates and feature name to one column. 
awk '{print $1, $2"-"$3":"$4}' ${filteredFile} > ${combinedFile}

#Append all feature column 2 values based on read ID. Each feature value is separated by a ">" symbol
awk '{arr[$1] = arr[$1] ">" $2} END {for (key in arr) print key, substr(arr[key], 2)}' ${combinedFile} > ${appendedFile}

