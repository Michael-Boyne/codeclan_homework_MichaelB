library(here)
library(tidyverse)
library(readxl)
library(janitor)
library(tidyr)

general_election_results <- read_xlsx(here("data/General-Election-2019-Results-Scotland.xlsx"))



general_election_results_clean <- general_election_results %>%
  select(1:9) %>%
  row_to_names(row_number = 1) %>%
  slice(1:59) %>%
  clean_names() %>%
  pivot_longer(!constituency, names_to = "party", values_to = "vote_count") %>%
  na.omit()

write_csv(general_election_results_clean, "clean_data/general_election_results.csv")



  
  