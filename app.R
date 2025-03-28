library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(shinythemes)

# Load Data
heart_data <- read.csv("heart.csv")

# Define UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Heart Disease Analysis Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("x_var", "Select X-axis Variable:", choices = names(heart_data), selected = "age"),
      selectInput("y_var", "Select Y-axis Variable:", choices = names(heart_data), selected = "chol"),
      selectInput("color_var", "Color by:", choices = names(heart_data), selected = "target"),
      checkboxInput("show_table", "Show Data Table", value = TRUE)
    ),
    mainPanel(
      plotlyOutput("scatterPlot"),
      DTOutput("dataTable")
    )
  )
)

server <- function(input, output) {
  
  # Render Scatter Plot
  output$scatterPlot <- renderPlotly({
    p <- ggplot(heart_data, aes_string(x = input$x_var, y = input$y_var, color = input$color_var)) +
      geom_point(size = 3, alpha = 0.7) +
      theme_minimal() +
      labs(title = "Scatter Plot of Heart Disease Data")
    ggplotly(p)
  })
  
  # Render Data Table
  output$dataTable <- renderDT({
    if (input$show_table) {
      datatable(heart_data, options = list(pageLength = 10))
    }
  })
}

# Run the Application
shinyApp(ui = ui, server = server)
