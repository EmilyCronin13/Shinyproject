library(shiny)
library(bslib)
library(thematic)

# Set default theme for ggplot2
ggplot2::theme_set(ggplot2::theme_minimal())
thematic_shiny()


ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly", 
                   base_font = font_google("Lato"), 
                   heading_font = font_google("Raleway")),
  
  div(
    style = "text-align: center; margin-bottom: 20px;",
    h1("DIG Trial Analysis")
  ),

  div(
    style = "background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px;",
    h4("Overview of This Study"),
    p("The DIG (Digitalis Investigation Group) Trial was conducted to evaluate the safety and efficacy of Digoxin in treating congestive heart failure.")
  )
) 
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)