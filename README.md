## Student Dropout Risk Prediction

This project builds a student dropout risk prediction system using the UCI Student Performance dataset.

Because no explicit dropout label exists, a proxy outcome was defined using a final grade threshold. A logistic regression classifier estimates dropout risk probabilities, which are aggregated to forecast expected dropout counts.

The project includes data ingestion, cleaning, feature engineering, modeling, evaluation, forecasting, and deployment through an interactive R Shiny dashboard.

### Tools
R, caret, pROC, dplyr, Shiny

### Disclaimer
Dropout risk is an analytical proxy and does not represent actual dropout events.
