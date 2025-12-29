library(pROC)
library(readr)

model <- readRDS("outputs/model_logistic.rds")
test  <- readRDS("outputs/test_data.rds")

test$probability <- predict(model, test, type = "response")
test$prediction  <- if_else(test$probability > 0.5, 1, 0)

roc_obj <- roc(test$dropout_risk, test$probability)

auc_value <- auc(roc_obj)

write.csv(
  data.frame(AUC = auc_value),
  "outputs/tables/model_performance.csv",
  row.names = FALSE
)
