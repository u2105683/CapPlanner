library(shiny)
library(dplyr)
library(DT)
library(shinyWidgets)



ui <- fluidPage(
  # Function to download selected records
  downloadButton("download", "Download.csv"),
  align="left",
  fluidRow(
    column("",
           width = 10, offset = 1,
           tags$h3("PTM Server Capacity Planner"),
           # Display Panel for users to choose selected score
           panel(
             sliderInput("storage", "Storage Score",
                         min =10, max = 100, value = 20),
             sliderInput("memory", "Memory Score",
                         min = 0, max = 100, value = 20),
             sliderInput("cpu", "CPU",
                         #min = 18, max = max(df$age), value = c(18,24)),
                         min = 0, max = 100, value = 20),
             
           ), 
           DT::dataTableOutput("table")
    )
  )
)

server <- function(input, output, session){
  
  # Read data file
  df <- read.csv("https://raw.githubusercontent.com/u2105683/CapPlanner/main/data2.csv")
  
  filtered_df <- reactive({
    
    res <- df %>% filter(Storage >= input$storage)
    res <- res %>% filter(Memory >= input$memory)
    res <- res %>% filter(CPU >= input$cpu)
  })
  
  output$counter <- renderText({
    res <- filtered_df() %>% select(ServerName) %>% n_distinct()
    res
    
  })
  
  output$table <- renderDataTable({
    res <- filtered_df() %>% distinct(ServerName,Storage,Memory,CPU)
    res
    
  })
}
shinyApp(ui,server)