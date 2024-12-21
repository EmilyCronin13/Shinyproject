library(shiny)
library(bslib)
library(thematic)

ggplot2::theme_set(ggplot2::theme_minimal())
thematic_shiny()

ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly", 
                   base_font = font_google("Lato"), 
                   heading_font = font_google("Raleway")),
  

  div(
    style = "text-align: center; margin-bottom: 20px;",
    h1("DIG Study")
  ),
  
  div(
    style = "background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px;",
    h4("Overview of This Study"),
    p("The DIG (Digitalis Investigation Group) Trial was conducted to evaluate the safety and efficacy of Digoxin in treating congestive heart failure.")
  ),
  

 # Putting in download button for dig - youtube tutorial add download file to shiny 
    sidebarLayout(
    sidebarPanel(
      sliderInput("age_range", "Age Range", 
                  min = 30, max = 100, value = c(30, 100)),
      selectInput("gender", "Gender", 
                  choices = c("All", "Male", "Female")),
      downloadButton("download_data", "Download Data")
    ),
    mainPanel(
      h3("Graphs "),
      p("Graphs.")
    )
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
