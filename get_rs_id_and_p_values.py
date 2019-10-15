with open("variants.tsv") as rs_id, open("20016_raw.gwas.imputed_v3.both_sexes.tsv") as summary, open(
        "20016_raw_rs_pval.tsv", "a") as output:
    dict_with_rs_id = {line.split()[0]: line.split()[5] for line in rs_id}
    counter = 0
    result = 0
    for line in summary:
        if line.split()[10] == "pval":
            continue
        output.write("{}\t{}\n".format(dict_with_rs_id[line.split()[0]], line.split()[10]))
        counter += 1
        if counter == 100000:
            result += counter
            counter = 0
            print("{} variants Done".format(result))
