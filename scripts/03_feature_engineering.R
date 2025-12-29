library(dplyr)
library(readr)

data <- read_csv("data/processed/student_clean.csv")

data_features <- data %>%
  mutate(
    dropout_risk = if_else(G3 < 7, 1, 0),
    dropout_risk = factor(dropout_risk)
  ) %>%
  select(-G1, -G2, -G3)

write_csv(data_features, "data/processed/student_features.csv")
