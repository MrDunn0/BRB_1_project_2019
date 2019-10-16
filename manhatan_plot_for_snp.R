library(qqman)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
setwd("/home/mikhail/Desktop/BI_2019/project/Pascal_output_processing/making_manhatan_plot")

manhattan_data <- read.csv(file = "20003_snp_manhattan_plot.tsv", header = FALSE, col.names = c("Variant", "Chromosome", "Position", "pvalue"), stringsAsFactors = FALSE, sep = "\t")

manhattan_data[manhattan_data$Chromosome == "X",2] <- "23"
manhattan_data$Chromosome <- as.numeric(manhattan_data$Chromosome)


str(manhattan_data)
rm(manhattan_data)

prep_manhattan_data <- manhattan_data %>% 
  group_by(Chromosome) %>% 
  summarise(chr_len=max(Position)) %>% 
  mutate(total=cumsum(as.numeric(chr_len))-as.numeric(chr_len)) %>%
  select(-chr_len) %>%
  left_join(manhattan_data, ., by=c("Chromosome"="Chromosome")) %>%
  arrange(Chromosome, Position) %>%
  mutate( cum_snp_position=Position+total)

prep_manhattan_data_without_NA <- na.omit(prep_manhattan_data)

str(prep_manhattan_data)
sum(is.na(prep_manhattan_data_without_NA))

axisdf = prep_manhattan_data %>% 
  group_by(Chromosome) %>%
  summarise(center = (as.double(max(cum_snp_position)) + as.double(min(cum_snp_position)) ) / 2)


test_data <- prep_manhattan_data %>%
  select(-Variant) %>% 
  group_by(Chromosome) %>% 
  top_n(seq(1, 1, 1000))



test_plot <- ggplot(test_data, aes(x = cum_snp_position, y=-log10(pvalue))) +
  geom_point( aes(color=as.factor(Chromosome)), alpha = 0.7, size=6) +
  scale_x_continuous(label = axisdf$Chromosome, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0),limits = c(0, 35)) +
  xlab('Genomic coordinate') + ylab('-log10(pvalue)')+
  theme_bw() +
  theme( 
    legend.position="none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size=8,angle = 45, hjust = 1),
    axis.line = element_line(colour = "black")
  )
  
  
png("pval_manhattan_plot_1.png")
manhattan_plot_1 <- ggplot(prep_manhattan_data_without_NA, aes(x = cum_snp_position, y=-log10(pvalue))) +
  geom_point( aes(color=as.factor(Chromosome)), alpha = 0.7, size=6) +
  scale_x_continuous(label = axisdf$Chromosome, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0),limits = c(0, 35)) +
  coord_fixed(1 * max(prep_manhattan_data_without_NA$cum_snp_position) / (max(-log10(prep_manhattan_data_without_NA$pvalue))+100))+
  xlab('Genomic coordinate') + ylab('-log10(pvalue)')+
  theme_bw() +
  theme( 
    legend.position="none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size=8,angle = 45, hjust = 1),
    axis.line = element_line(colour = "black")
  )
dev.off()

dev.print(manhattan_plot_1, "manhattan_plot.pdf")

rm(manhattan_plot_1)

png("test.png")
ggplot(prep_manhattan_data_without_NA, aes(x=cum_snp_position, y=-log10(pvalue))) +
  geom_point( aes(color= as.factor(Chromosome), alpha=0.9, size=2.8)) +
  scale_x_continuous(label = axisdf$Chromosome, breaks= axisdf$center ) +
  xlab('Genomic coordinate')+
  theme( legend.position="none", axis.text.x = element_text(angle = 15, hjust = 1))
dev.off()
