library(tidyverse)
library(ggplot2)
library(readr)

# Load data
math <- read.csv("C:/Users/LENOVO/OneDrive/Documents/eti files/git project 1/data/student-mat.csv", sep = ";")
por <- read.csv("C:/Users/LENOVO/OneDrive/Documents/eti files/git project 1/data/student-por.csv", sep = ";")
student_data <- bind_rows(math, por)

# Create binary dropout variable
student_data <- student_data %>%
  mutate(dropout_risk = ifelse(G3 < 10, "High", "Low"))

# Dropout risk distribution
ggplot(student_data, aes(dropout_risk)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Dropout Risk Distribution", x = "Risk", y = "Count")

# Study time vs. dropout
ggplot(student_data, aes(factor(studytime), fill = dropout_risk)) +
  geom_bar(position = "fill") +
  labs(title = "Study Time vs. Dropout Risk", x = "Study Time (1-4)", y = "Proportion")

# Alcohol consumption vs. dropout
ggplot(student_data, aes(Walc, Dalc, color = dropout_risk)) +
  geom_jitter(alpha = 0.5) +
  labs(title = "Alcohol Consumption and Dropout Risk", x = "Weekend", y = "Workday")

