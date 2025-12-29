library(dplyr)
library(readr)

data <- read_csv("data/raw/student_combined.csv")

data_clean <- data %>%
  mutate(across(where(is.character), as.factor)) %>%
  drop_na()

write_csv(data_clean, "data/processed/student_clean.csv")
