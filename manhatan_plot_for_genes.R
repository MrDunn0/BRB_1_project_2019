library(qqman)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
setwd("/home/mikhail/Desktop/BI_2019/project/Pascal_output_processing/making_manhatan_plot")
manhattan_data <- read.csv(file = "manhattan_data.txt", header = TRUE, sep = "\t")
manhattan_data %>% arrange(chromosome)

str(prepared_manhattan_data)
str(manhattan_data)
rm(prepared_manhattan_data)

prepared_manhattan_data <- manhattan_data %>% 
  group_by(chromosome) %>%
  summarise(chr_len = max(start)) %>% 
  mutate(total = cumsum(chr_len) - chr_len) %>% 
  left_join(manhattan_data, . , by = c("chromosome" = "chromosome")) %>% 
  mutate(cum_position = start + total) %>% 
  arrange(chromosome, start)

axisdf = prepared_manhattan_data %>% 
  group_by(chromosome) %>%
  summarise(center = (as.double(max(cum_position)) + as.double(min(cum_position)) ) / 2)

ggplot(prepared_manhattan_data, aes(x = cum_position, y=-log10(pvalue))) +
  geom_point( aes(color=chromosome), alpha = 0.7, size=6) +
  scale_x_continuous(label = axisdf$chromosome, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0),limits = c(1, 10)) +
  xlab('Genomic coordinate') + ylab('pvalue')+
  theme_bw() +
  theme( 
    legend.position="none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size=8,angle = 45),
    axis.line = element_line(colour = "black")
  )


ggplot(prepared_manhattan_data, aes(x=cum_position, y=-log10(pvalue))) +
  geom_point( aes(color= chromosome, alpha=0.9, size=2.8)) +
  scale_x_continuous(label = axisdf$chromosome, breaks= axisdf$center ) +
  xlab('Genomic coordinate')+
  theme( legend.position="none", axis.text.x = element_text(angle = 15))+

cumsum(1:10)
?summarise
