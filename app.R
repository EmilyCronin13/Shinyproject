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
    ),
    layout_columns(
      card(
        card_header("Patient Summary by Treatment Group", class = "h6 text-success"),
        plotlyOutput("treatment_summary_plot")
      ),
      card(
        card_header("Mortality by Treatment Group", class = "h6 text-success"),
        plotlyOutput("mortality_by_treatment_plot")
      ),
      card(
        card_header("CVD Influence on Mortality by Treatment Group", class = "h6 text-success"),
        plotlyOutput("CVD_mortality_plot")
      ),
      card(
        card_header("Summary Table", class = "h6 text-success"),
        DTOutput("summary_table")
      ),
      col_widths = c(6, 6, 6),
      row_heights = c(6, 6)
    )
  ),
  
  div(
    class = "summary-box",
    h4("Study Summary"),
    p("The Digitalis Investigation Group (DIG) trial was a landmark study evaluating the role of digoxin in treating patients with heart failure in sinus rhythm. Conducted across more than 300 centers in the U.S. and Canada, this double-blind randomized trial recruited patients with heart failure and ejection fraction ≤45%.",
      class = "summary-text"),
    p("The trial assessed outcomes including cardiovascular mortality, hospitalizations, and symptomatic relief in patients treated with digoxin or placebo. Key findings included reductions in hospitalizations due to worsening heart failure, though overall mortality rates remained unchanged.",
      class = "summary-text"),
    p("The DIG dataset remains a valuable resource for understanding the therapeutic benefits and safety concerns associated with digoxin therapy.",
      class = "summary-text")
  )
)

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
  
  output$total_study_patients <- renderText({
    nrow(full_data)
  })
  
  output$total_patients <- renderText({
    nrow(filtered_data())
  })
  
  output$avg_age <- renderText({
    filtered_data() %>% summarize(AverageAge = mean(AGE, na.rm = TRUE)) %>% pull(AverageAge)
  })
  
  output$treatment_summary_plot <- renderPlotly({
    treatment_placebo_cp <- full_data %>%
      count(TRTMT) %>%
      mutate(percentage = round(n / sum(n) * 100, 2))
    
    plot_ly(treatment_placebo_cp) %>%
      add_trace(
        x = ~TRTMT, 
        y = ~n, 
        type = 'bar', 
        name = ~TRTMT,
        text = ~paste(n, " patients", "<br>", percentage, "%"), 
        textposition = 'auto',
        marker = list(
          color = c('tomato', 'lightgreen')[as.factor(treatment_placebo_cp$TRTMT)],
          line = list(color = 'rgb(8,48,107)', width = 1.3)
        )
      ) %>%
      layout(
        title = "Patient Summary by Treatment Group",
        barmode = 'group',
        xaxis = list(title = "Patients treatment Group"),
        yaxis = list(title = "Number of patients in group"),
        showlegend = TRUE,  
        legend = list(
          title = list(text = 'Treatment group each patient belongs to'),
          x = 1, y = 0.8, 
          bordercolor = 'rgba(0, 0, 0, 0.1)',  
          borderwidth = 2
        )
      )
  })
  
  output$mortality_by_treatment_plot <- renderPlotly({
    mortality <- full_data %>%
      group_by(Treatment_Group = factor(TRTMT, labels = c("Placebo", "Digoxin")), 
               Mortality_Status = factor(DEATH, labels = c("Alive", "Dead"))) %>%
      summarise(Count = n(), .groups = "drop")
    
    plot_ly(mortality, 
            x = ~Treatment_Group, 
            y = ~Count, 
            color = ~Mortality_Status, 
            type = 'bar',
            text = ~paste(Count, " patients"), 
            textposition = 'auto',
            marker = list(line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
      layout(
        title = "Mortality by Treatment Group",
        barmode = 'group',
        xaxis = list(title = "Treatment Group"),
        yaxis = list(title = "Number of Patients"),
        legend = list(title = list(text = "Mortality Status"))
      )
  })
  
  output$CVD_mortality_plot <- renderPlotly({
    CVD_by_group <- ggplot(full_data, mapping = aes(x = CVD, fill = factor(DEATH, labels = c("Alive", "Dead")))) +
      geom_bar(color = "black", width = 0.8) +
      facet_wrap(~ factor(TRTMT, labels = c("Placebo", "Digoxin")), nrow = 1) +
      theme_test() +
      scale_fill_manual(values = c("Alive" = "skyblue", "Dead" = "tomato")) +
      labs(
        title = "Impact of Cardiovascular Disease on Mortality by Treatment Group",
        x = "Cardiovascular Disease",
        y = "Count"
      ) +
      guides(fill = guide_legend(title = "Mortality Status"))
    
    ggplotly(CVD_by_group)
  })
  
  output$summary_table <- renderDT({
    data <- filtered_data()
    
    summary <- data %>%
      group_by(TRTMT) %>%
      summarize(
        AGE_mean = round(mean(AGE, na.rm = TRUE), 1),
        AGE_sd = round(sd(AGE, na.rm = TRUE), 1),
        BMI_mean = round(mean(BMI, na.rm = TRUE), 1),
        BMI_sd = round(sd(BMI, na.rm = TRUE), 1),
        Patients = n(),
        Male = sum(SEX == 1, na.rm = TRUE),
        Female = sum(SEX == 2, na.rm = TRUE)
      ) %>%
      mutate(Treatment = ifelse(TRTMT == 1, "Digoxin", "Placebo")) %>%
      select(Treatment, Patients, AGE_mean, AGE_sd, BMI_mean, BMI_sd, Male, Female)
    
    datatable(summary, options = list(pageLength = 5, scrollX = TRUE))
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste("Digitalis_Data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)
