library(shiny)
library(bslib)
library(thematic)
library(dplyr)

ggplot2::theme_set(ggplot2::theme_minimal())
thematic_shiny()

server <- function(input, output) {
  full_data <- read.csv("DIG.csv")
  
  filtered_data <- reactive({
    data <- full_data %>%
      filter(AGE >= input$age_range[1] & AGE <= input$age_range[2])
    
    if (input$gender != "All") {
      data <- data %>% filter(SEX == ifelse(input$gender == "Male", 1, 2))
    }
    data
  })
  
  output$total_patients <- renderText({
    nrow(filtered_data())
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste("Filtered_DIG_Data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly", 
                   base_font = font_google("Lato"), 
                   heading_font = font_google("Raleway")),
  
  div(
    style = "text-align: center; margin-bottom: 20px;",
    h1("DIG Trial Analysis")
  ),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("age_range", "Age Range", 
                  min = 30, max = 100, value = c(30, 100)),
      selectInput("gender", "Gender", 
                  choices = c("All", "Male", "Female")),
      downloadButton("download_data", "Download Data")
    ),
    mainPanel(
      h3("Filtered Patients:"),
      textOutput("total_patients")
    )
  )
)

shinyApp(ui = ui, server = server)

    