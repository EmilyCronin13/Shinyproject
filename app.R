
library(shiny)

ui <- fluidPage(
  titlePanel("Testing shiny !"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("slider", "Select a value:", 1, 100, 50)
    ),
    mainPanel(
      textOutput("value")
    )
  )
)

server <- function(input, output) {
  output$value <- renderText({
    paste("You selected:", input$slider)
  })
}

shinyApp(ui = ui, server = server)