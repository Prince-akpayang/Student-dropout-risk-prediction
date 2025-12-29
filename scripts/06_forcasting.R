library(dplyr)

test <- readRDS("outputs/test_data.rds")

test$probability <- predict(
  readRDS("outputs/model_logistic.rds"),
  test,
  type = "response"
)

forecast <- test %>%
  summarise(
    expected_dropouts = sum(probability),
    high_risk_students = sum(probability > 0.5),
    total_students = n()
  )

write.csv(
  forecast,
  "outputs/tables/dropout_forecast.csv",
  row.names = FALSE
)
