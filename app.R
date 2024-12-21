library(shiny)
library(tidyverse)
library(bslib)
library(thematic)
library(plotly)
library(DT)

ggplot2::theme_set(ggplot2::theme_minimal())
thematic_shiny()

ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly",
                   base_font = font_google("Lato"),
                   heading_font = font_google("Raleway")),
  
  tags$style(HTML("
    .description-box, .summary-box {
      background: linear-gradient(to right, #ffffff, #f0f4f8); 
      border-left: 5px solid #007BFF; 
      border-radius: 10px; 
      padding: 20px; 
      margin: 20px auto; 
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      color: black;
    }
    .description-text, .summary-text {
      font-size: 14px;
      color: #555;
      line-height: 1.8;
    }
  ")),
  
  
  #Adding in the giphs from giphy . com ! and the digitalis logo 
  div(
    style = "text-align: center; margin-bottom: 20px;",
    div(
      style = "display: flex; justify-content: center; align-items: center; gap: 20px;",
      img(src = "https://media.giphy.com/media/ToMjGpAibV4AwKryEXS/giphy.gif", 
          style = "width: 70px; height: 70px; border-radius: 50%; object-fit: cover; border: 3px solid white;"),
      h1(
        HTML("<b>DIG Trial Analysis</b>"),
        style = "
          font-size: 36px; 
          font-family: 'Raleway', sans-serif; 
          background: linear-gradient(90deg, #86C7ED, #FFD700); 
          -webkit-background-clip: text; 
          -webkit-text-fill-color: transparent; 
          text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);
        "
      ),
      img(src = "https://media.giphy.com/media/l3YSj6Oirgkb18AkE/giphy.gif", 
          style = "width: 80px; height: 80px; border-radius: 50%; object-fit: cover;")
    ),
    h3(
      "Investigating the Safety and Efficacy of Digoxin in Treating Congestive Heart Failure",
      style = "
        font-size: 18px; 
        color: #CCCCCC; 
        margin-top: 10px; 
        font-family: 'Lato', sans-serif; 
        text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
      "
    )
  ),
  
  div(
    class = "description-box",
    div(
      style = "display: flex; align-items: center; margin-bottom: 10px;",
      icon("info-circle", class = "fa-2x", style = "color: #007BFF; margin-right: 10px;"),
      h4("Overview of This Study", style = "margin: 0; color: #333; font-weight: bold;")
    ),
    p("The DIG (Digitalis Investigation Group) Trial was a randomized, double-blind, multicenter trial conducted across more than 300 centers in the United States and Canada. The study aimed to evaluate the safety and efficacy of Digoxin in treating congestive heart failure in sinus rhythm.",
      class = "description-text"),
    p("Outcomes assessed included cardiovascular mortality, hospitalization or death from worsening heart failure, and other cardiovascular or non-cardiovascular hospitalizations.",
      class = "description-text")
  ),
  
  fluidRow(
    column(4,
           value_box(
             title = "Patients in Study",
             textOutput("total_study_patients"),
             showcase = icon("clipboard"),
             theme = "success"
           )),
    column(4,
           value_box(
             title = "Average Age (Filtered)",
             textOutput("avg_age"),
             showcase = icon("user"),
             theme = "info"
           )),
    column(4,
           value_box(
             title = "Total Patients (Filtered)",
             textOutput("total_patients"),
             showcase = icon("users"),
             theme = "primary"
           ))
  ),
  
  page_sidebar(
    sidebar = sidebar(
      class = "bg-secondary",
      h4("Filters"),
      sliderInput("age_range", "Age Range", 
                  min = 30, max = 100, value = c(30, 100)),
      selectizeInput("gender", "Gender", 
                     choices = c("All", "Male", "Female"), selected = "All", width = "100%"),
      
      downloadButton("download_data", "Download Digitalis Data", class = "btn-primary"),
      
      tags$img(src = "digi image.png", style = "width: 100%; height: auto; margin-top: 20px;")
    ))
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
