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