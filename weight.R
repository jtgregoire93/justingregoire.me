# Install and load required packages
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("gargle", quietly = TRUE)) install.packages("gargle")
if (!requireNamespace("googlesheets4", quietly = TRUE)) install.packages("googlesheets4")
if (!requireNamespace("googledrive", quietly = TRUE)) install.packages("googledrive")

library(shiny)
library(gargle)
library(googlesheets4)
library(googledrive)

# Set the path to the JSON key file for the service account

# Define UI for the app
ui <- fluidPage(
  titlePanel("Weight Entry Form"),
  sidebarLayout(
    sidebarPanel(
      numericInput("justin_weight", "Justin's Weight (lb):", value = NULL, min = 0),
      numericInput("combined_weight", "Justin + Phoebe's Weight (lb):", value = NULL, min = 0),
      dateInput("entry_date", "Date:", value = Sys.Date()),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      verbatimTextOutput("message")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Authenticate using the service account key
  
  observeEvent(input$submit, {
    if (is.null(input$justin_weight) || is.null(input$combined_weight)) {
      output$message <- renderText("Please enter both weights.")
    } else {
      entry <- data.frame(
        date = as.character(input$entry_date),
        justin_weight = input$justin_weight,
        combined_weight = input$combined_weight,
        stringsAsFactors = FALSE
      )
      
      # Save the entry to a local CSV file
      if (file.exists("weight_entries.csv")) {
        write.table(entry, "weight_entries.csv", append = TRUE, sep = ",", col.names = FALSE, row.names = FALSE)
      } else {
        write.table(entry, "weight_entries.csv", append = FALSE, sep = ",", col.names = TRUE, row.names = FALSE)
      }
      
      output$message <- renderText("Entry submitted successfully!")
    }
  })
}

# Run the app
shinyApp(ui = ui, server = server)