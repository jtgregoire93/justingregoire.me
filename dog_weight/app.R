library(shiny)
library(ggplot2)
library(plotly)

max_weight <- 205

# Define the UI
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(6, numericInput("dog1", "Dog 1:", value = 25, min = 5, max = 90)),
        column(6, numericInput("dog2", "Dog 2:", value = 25, min = 5, max = 90)),
        column(6, numericInput("dog3", "Dog 3:", value = 25, min = 5, max = 90)),
        column(6, numericInput("phoebe", "Phoebe:", value = 60, min = 55, max = 65))
      )
    ),
    mainPanel(
      plotlyOutput("weight_plot")  # Output for weight status plot
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$weight_plot <- renderPlotly({
    weights <- c(input$dog1, input$dog2, input$dog3, input$phoebe)
    total_weight <- sum(weights)
    
    weight_data <- data.frame(
      Dog = c("Dog 1", "Dog 2", "Dog 3", "Phoebe"),
      Weight = weights
    )
    
    gg <- ggplot(weight_data, aes(x = "", y = Weight, fill = Dog)) +
      geom_bar(stat = "identity") +
      labs(title = "Dog Weights Status", y = "Weight") +
      scale_fill_brewer(palette = "Set3") +
      theme_minimal() +
      theme(axis.text.x = element_blank(),  # Remove x-axis text
            axis.ticks.x = element_blank(), # Remove x-axis ticks
            legend.position = "none") +     # Remove legend
      geom_hline(yintercept = max_weight, linetype = "dashed", color = "black") +
      annotate("text", x = 0.6, y = max_weight + 5, label = "Max Weight", color = "black")
    
    ggplotly(gg)  # Convert ggplot to interactive plot
  })
}

# Run the application
shinyApp(ui = ui, server = server)
