library(readr)
library(tidyverse)
library(dplyr)


endangered_species <- read_csv("Documents/Stat 451/endangered_species.csv", skip=1)

# Top 10 species that are endangered
endangered_species$Value <- as.numeric(endangered_species$Value)
species_total <- endangered_species %>% aggregate(Value ~ Series + Year, sum) %>% 
  arrange(desc(Value))


species_plot <- ggplot(species_total, aes(x = Year, y = Value, color = Series, group = Series, linetype = Series)) + geom_line() +
  labs(title = 'Total Number of Endangered Species Over the Years By Group', x = 'Year', y = 'Count',
       color = 'Species Type') + 
  scale_color_manual(values = c('Threatened Species: Invertebrates (number)' = 'red', 
                                'Threatened Species: Plants (number)' = 'green', 
                                'Threatened Species: Total (number)' = 'black', 
                                'Threatened Species: Vertebrates (number)' = 'purple'),
                    labels = c('Invertebrates', 'Plants', 'Total', 'Vertebrates')) +
  scale_linetype_manual(values = c('Threatened Species: Invertebrates (number)' = 'solid', 
                                   'Threatened Species: Plants (number)' = 'solid', 
                                   'Threatened Species: Total (number)' = 'dashed', 
                                   'Threatened Species: Vertebrates (number)' = 'solid')) +
  guides(linetype = 'none',
         color = guide_legend(override.aes = list(linetype = c('solid','solid', 'dashed', 'solid')))) +
  scale_x_continuous(breaks = unique(species_total$Year)) +
  theme_minimal()

species_plot

