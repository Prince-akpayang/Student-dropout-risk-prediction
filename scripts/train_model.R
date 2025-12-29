# Title: Train Student Dropout Risk Model
library(tidyverse)
library(tidymodels)
library(readr)

# Load data
math <- read.csv("data/student-mat.csv", sep = ";")
por <- read.csv("data/student-por.csv", sep = ";")

# Combine both datasets
student_data <- bind_rows(math, por)

# Create target variable
student_data <- student_data %>%
  mutate(dropout_risk = ifelse(G3 < 10, 1, 0),
         dropout_risk = as.factor(dropout_risk)) %>%
  select(-G3)

# Split data
set.seed(123)
split <- initial_split(student_data, strata = dropout_risk)
train <- training(split)
test <- testing(split)

# Preprocessing recipe
recipe <- recipe(dropout_risk ~ ., data = train) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

# Logistic regression model
log_model <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

# Workflow
wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(log_model)

# Train
fit <- fit(wf, train)

# Save model for Shiny app
saveRDS(fit, file = "app/dropout_model.rds")

# Print accuracy
preds <- predict(fit, test) %>%
  bind_cols(test) %>%
  metrics(truth = dropout_risk, estimate = .pred_class)

print(preds)
