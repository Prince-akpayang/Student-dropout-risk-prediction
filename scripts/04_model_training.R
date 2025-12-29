library(caret)
library(readr)

data <- read_csv("data/processed/student_features.csv")

set.seed(123)

index <- createDataPartition(data$dropout_risk, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]

model <- glm(
  dropout_risk ~ .,
  data = train,
  family = binomial
)

saveRDS(model, "outputs/model_logistic.rds")
saveRDS(test, "outputs/test_data.rds")
