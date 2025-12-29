library(shiny)
library(dplyr)
library(readr)
library(ggplot2)

model <- readRDS("model/model_logistic.rds")

feature_template <- read_csv("data/processed/student_features.csv") %>%
  select(-dropout_risk) %>%
  slice(1)

math <- read.csv("data/raw/student-mat.csv", sep = ";")
por  <- read.csv("data/raw/student-por.csv", sep = ";")


student_data <- bind_rows(math, por) %>%
  mutate(dropout_risk = ifelse(G3 < 10, "High", "Low"))

ui <- fluidPage(
  
  titlePanel("Student Dropout Risk Dashboard"),
  
  tabsetPanel(
    
    tabPanel(
      "Individual Prediction",
      
      sidebarLayout(
        sidebarPanel(
          h4("Student Information"),
          
          selectInput("sex", "Sex", c("F", "M")),
          numericInput("age", "Age", value = 17, min = 15, max = 22),
          selectInput("address", "Address Type", c("U", "R")),
          selectInput("famsize", "Family Size", c("LE3", "GT3")),
          selectInput("Pstatus", "Parent Status", c("T", "A")),
          
          numericInput("Medu", "Mother Education Level", 2, 0, 4),
          numericInput("Fedu", "Father Education Level", 2, 0, 4),
          
          selectInput("schoolsup", "School Support", c("yes", "no")),
          numericInput("studytime", "Weekly Study Time", 2, 1, 4),
          numericInput("failures", "Previous Academic Failures", 0, 0, 4),
          numericInput("absences", "Total Absences", 4, 0, 93),
          
          actionButton("predict", "Predict Risk")
        ),
        
        mainPanel(
          h4("Prediction Result"),
          verbatimTextOutput("result"),
          
          hr(),
          
          h4("Variable Definitions"),
          
          helpText(
            "Sex: Student gender.",
            "Age: Student age in years.",
            "Address Type: Urban or rural residence.",
            "Family Size: Household size indicator.",
            "Parent Status: Whether parents live together.",
            "Mother and Father Education: Highest education level from 0 (none) to 4 (higher education).",
            "School Support: Extra educational support provided by the school.",
            "Study Time: Weekly study time category from low (1) to high (4).",
            "Previous Failures: Number of past class failures.",
            "Absences: Number of school absences recorded."
          )
        )
      )
    ),
    
    tabPanel(
      "Data Summary",
      
      fluidRow(
        column(
          6,
          plotOutput("risk_dist")
        ),
        column(
          6,
          plotOutput("studytime_plot")
        )
      ),
      
      fluidRow(
        column(
          12,
          plotOutput("alcohol_plot")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict, {
    
    new_data <- feature_template %>%
      mutate(
        sex = input$sex,
        age = input$age,
        address = input$address,
        famsize = input$famsize,
        Pstatus = input$Pstatus,
        Medu = input$Medu,
        Fedu = input$Fedu,
        schoolsup = input$schoolsup,
        studytime = input$studytime,
        failures = input$failures,
        absences = input$absences
      )
    
    probability <- predict(model, newdata = new_data, type = "response")
    
    risk_label <- ifelse(
      probability > 0.5,
      "High Dropout Risk",
      "Low Dropout Risk"
    )
    
    output$result <- renderText({
      paste0(
        "Predicted Dropout Probability: ",
        round(probability * 100, 2),
        "%\n",
        risk_label
      )
    })
  })
  
  output$risk_dist <- renderPlot({
    ggplot(student_data, aes(dropout_risk)) +
      geom_bar(fill = "steelblue") +
      labs(
        title = "Dropout Risk Distribution",
        x = "Risk Level",
        y = "Number of Students"
      )
  })
  
  output$studytime_plot <- renderPlot({
    ggplot(student_data, aes(factor(studytime), fill = dropout_risk)) +
      geom_bar(position = "fill") +
      labs(
        title = "Study Time and Dropout Risk",
        x = "Study Time Category",
        y = "Proportion"
      )
  })
  
  output$alcohol_plot <- renderPlot({
    ggplot(student_data, aes(Walc, Dalc, color = dropout_risk)) +
      geom_jitter(alpha = 0.5) +
      labs(
        title = "Alcohol Consumption and Dropout Risk",
        x = "Weekend Alcohol Consumption",
        y = "Weekday Alcohol Consumption"
      )
  })
}

shinyApp(ui, server)
