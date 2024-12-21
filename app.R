library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("DIG Study"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("age_range", "Age Range", min = 30, max = 100, value = c(30, 100)),
      selectInput("gender", "Gender", choices = c("All", "Male", "Female"), selected = "All")
    ),
    mainPanel(
      textOutput("total_study_patients"),
      textOutput("avg_age"),
      textOutput("total_patients")
    )
  )
) 
#comment #daaah

server <- function(input, output) {
  full_data <- tibble(AGE = sample(30:100, 1000, replace = TRUE), SEX = sample(1:2, 1000, replace = TRUE))
  
  filtered_data <- reactive({
    data <- full_data %>% filter(AGE >= input$age_range[1] & AGE <= input$age_range[2])
    if (input$gender != "All") {
      data <- data %>% filter(SEX == ifelse(input$gender == "Male", 1, 2))
    }
    data
  })
  
  output$total_study_patients <- renderText({
    paste("Total Patients in Study:", nrow(full_data))
  })
  
  output$total_patients <- renderText({
    paste("Filtered Patients:", nrow(filtered_data()))
  })
  
  output$avg_age <- renderText({
    paste("Average Age (Filtered):", round(mean(filtered_data()$AGE, na.rm = TRUE), 1))
  })
}

shinyApp(ui = ui, server = server)