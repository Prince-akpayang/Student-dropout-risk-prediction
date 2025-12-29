library(readr)
library(dplyr)

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

# url_mat <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student-mat.csv"
# url_por <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student-por.csv"

math <- read.csv("C:/Users/LENOVO/OneDrive/Documents/eti files/git project 1/data/student-mat.csv", sep = ";")
por <- read.csv("C:/Users/LENOVO/OneDrive/Documents/eti files/git project 1/data/student-por.csv", sep = ";")

math$subject <- "math"
por$subject <- "portuguese"

combined <- bind_rows(math, por)

write_csv(combined, "data/raw/student_combined.csv")
