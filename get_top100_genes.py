pascal_file = input()
with open(pascal_file, "r") as pascal_output:
    genes_p_values = sorted([float(line.split()[7]) for line in pascal_output if line.split()[7] != "pvalue"])
    top_100_genes_with_min_p_values = genes_p_values[:100]

with open(pascal_file, "r") as pascal_output, open(pascal_file + "_selected_genes.txt", "a") as selected_genes:
    for line in pascal_output:
        if line.split()[7] == "pvalue":
            print(line)
            continue
        elif float(line.split()[7]) in top_100_genes_with_min_p_values:
            selected_genes.write(line)
            # print(line, end="")
