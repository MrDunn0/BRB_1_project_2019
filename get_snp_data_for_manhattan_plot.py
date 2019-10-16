with open("variants.tsv", "r") as variants, open("20003.tsv", "r") as trait_summary:
    # dict_with_chrs_and_positions = {line.split()[0]:line.split()[] for line in rs_id}
    disct_with_chrs_and_positions = {line.split()[0]: list(line.split()[1:3]) for line in variants}

    for second_line in trait_summary:
        variant = second_line.split()[0]
        pvalue = second_line.split()[11]
        if variant == "variant":
            continue
        else:
            print("{}\t{}\t{}\t{}".format(variant, disct_with_chrs_and_positions[variant][0], disct_with_chrs_and_positions[variant][1], pvalue))
