library(tidyverse)

endangered <- read_csv("UN_threatened_species.csv", skip=1)
endangered <- endangered %>% 
  mutate(`Region/Country/Area` = endangered$...2) %>% 
  subset(select = -...2)
endangered <- iconv(endangered$`Region/Country/Area`, to = "UTF-8", sub = "")
save(endangered, file = "endangered.RData")



