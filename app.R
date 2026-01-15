# app.R
# Run this app with: shiny::runApp("app.R")
#install.packages(c("shiny", "ggplot2", "DT"))
library(shiny)
library(ggplot2)
library(DT)

# Define UI with sidebar
ui <- fluidPage(
  
  # Application title
  titlePanel("Data Explorer Dashboard"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # File upload
      h4("Data Import"),
      fileInput("file", "Upload CSV File",
                accept = c(".csv", ".txt"),
                buttonLabel = "Browse..."),
      
      hr(),
      
      # Sample data selection
      h4("Or Use Sample Data"),
      selectInput("dataset", "Choose sample dataset:",
                  choices = c("mtcars", "iris", "diamonds", "mpg"),
                  selected = "mtcars"),
      
      hr(),
      
      # Plot controls
      h4("Plot Controls"),
      selectInput("xvar", "X Variable:", choices = NULL),
      selectInput("yvar", "Y Variable:", choices = NULL),
      
      checkboxInput("smooth", "Add trend line", value = FALSE),
      
      sliderInput("pointsize", "Point size:",
                  min = 1, max = 10, value = 3, step = 0.5),
      
      selectInput("theme", "Plot theme:",
                  choices = c("Classic", "Minimal", "Dark", "Light"),
                  selected = "Classic"),
      
      hr(),
      
      # Data filter
      h4("Data Filter"),
      sliderInput("rows", "Number of rows to show:",
                  min = 5, max = 100, value = 20),
      
      hr(),
      
      # Action button
      actionButton("update", "Update Dashboard", 
                   icon = icon("refresh"),
                   class = "btn-primary"),
      
      # Download button
      downloadButton("downloadData", "Download Filtered Data"),
      
      width = 3  # Sidebar width (1-12 scale)
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      
      # Tabset panel
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Plot",
                           br(),
                           plotOutput("scatterPlot", height = "500px"),
                           br(),
                           h5("Plot Summary"),
                           verbatimTextOutput("plotSummary")
                  ),
                  
                  tabPanel("Data Table",
                           br(),
                           DTOutput("dataTable"),
                           br(),
                           h5("Data Summary"),
                           verbatimTextOutput("dataSummary")
                  ),
                  
                  tabPanel("Statistics",
                           br(),
                           h4("Summary Statistics"),
                           tableOutput("statTable"),
                           br(),
                           h4("Correlation Matrix"),
                           verbatimTextOutput("correlation")
                  ),
                  
                  tabPanel("About",
                           br(),
                           h4("About This App"),
                           p("This Shiny app demonstrates a complete dashboard with:"),
                           tags$ul(
                             tags$li("File upload functionality"),
                             tags$li("Interactive plotting with ggplot2"),
                             tags$li("Data table with search and pagination"),
                             tags$li("Dynamic variable selection"),
                             tags$li("Data filtering and downloading")
                           ),
                           br(),
                           h4("Instructions:"),
                           p("1. Upload a CSV file or select a sample dataset"),
                           p("2. Choose variables for the X and Y axes"),
                           p("3. Customize the plot using the controls"),
                           p("4. Click 'Update Dashboard' to apply changes"),
                           p("5. Explore different tabs for data views")
                  )
      ),
      width = 9  # Main panel width
    )
  ),
  
  # Add some custom CSS
  tags$head(
    tags$style(HTML("
      .btn-primary {
        background-color: #4285f4;
        border-color: #4285f4;
        width: 100%;
      }
      .well {
        background-color: #f8f9fa;
      }
      hr {
        border-top: 1px solid #ddd;
      }
    "))
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive value for data
  data <- reactiveVal(NULL)
  
  # Load sample data when dataset changes
  observeEvent(input$dataset, {
    req(input$dataset)
    
    df <- switch(input$dataset,
                 "mtcars" = mtcars,
                 "iris" = iris,
                 "diamonds" = diamonds,
                 "mpg" = ggplot2::mpg)
    
    # Convert to data frame
    df <- as.data.frame(df)
    data(df)
    
    # Update variable choices
    updateSelectInput(session, "xvar", choices = names(df))
    updateSelectInput(session, "yvar", choices = names(df))
  })
  
  # Load uploaded file
  observeEvent(input$file, {
    req(input$file)
    
    tryCatch({
      df <- read.csv(input$file$datapath)
      data(df)
      
      # Update variable choices
      updateSelectInput(session, "xvar", choices = names(df))
      updateSelectInput(session, "yvar", choices = names(df))
      
    }, error = function(e) {
      showNotification(paste("Error:", e$message), type = "error")
    })
  })
  
  # Initialize with mtcars
  observe({
    if (is.null(data())) {
      data(mtcars)
      updateSelectInput(session, "xvar", choices = names(mtcars), selected = "hp")
      updateSelectInput(session, "yvar", choices = names(mtcars), selected = "mpg")
    }
  })
  
  # Get filtered data
  filteredData <- eventReactive(input$update, {
    req(data())
    head(data(), input$rows)
  }, ignoreNULL = FALSE)
  
  # Create scatter plot
  output$scatterPlot <- renderPlot({
    df <- filteredData()
    req(df, input$xvar, input$yvar)
    
    # Check if variables are numeric
    if (!is.numeric(df[[input$xvar]]) || !is.numeric(df[[input$yvar]])) {
      plot(1, type = "n", xlab = "", ylab = "", main = "Please select numeric variables")
      return()
    }
    
    # Create plot
    p <- ggplot(df, aes_string(x = input$xvar, y = input$yvar)) +
      geom_point(size = input$pointsize, color = "#4285f4", alpha = 0.7) +
      labs(title = paste(input$yvar, "vs", input$xvar),
           x = input$xvar,
           y = input$yvar) +
      theme_bw()
    
    # Add trend line if selected
    if (input$smooth) {
      p <- p + geom_smooth(method = "lm", se = TRUE, color = "red", alpha = 0.2)
    }
    
    # Apply theme
    p <- switch(input$theme,
                "Classic" = p + theme_classic(),
                "Minimal" = p + theme_minimal(),
                "Dark" = p + theme_dark(),
                "Light" = p + theme_light(),
                p)
    
    p
  })
  
  # Display data table
  output$dataTable <- renderDT({
    df <- filteredData()
    req(df)
    
    datatable(df,
              options = list(
                pageLength = 10,
                scrollX = TRUE,
                searching = TRUE
              ),
              rownames = FALSE)
  })
  
  # Summary statistics
  output$statTable <- renderTable({
    df <- filteredData()
    req(df)
    
    # Get numeric columns only
    num_df <- df[sapply(df, is.numeric)]
    
    if (ncol(num_df) > 0) {
      stats <- data.frame(
        Variable = names(num_df),
        Mean = sapply(num_df, mean, na.rm = TRUE),
        SD = sapply(num_df, sd, na.rm = TRUE),
        Min = sapply(num_df, min, na.rm = TRUE),
        Max = sapply(num_df, max, na.rm = TRUE),
        N = sapply(num_df, function(x) sum(!is.na(x)))
      )
      round(stats, 3)
    }
  }, striped = TRUE, hover = TRUE)
  
  # Correlation matrix
  output$correlation <- renderPrint({
    df <- filteredData()
    req(df)
    
    num_df <- df[sapply(df, is.numeric)]
    
    if (ncol(num_df) > 1) {
      cor_matrix <- cor(num_df, use = "complete.obs")
      print(round(cor_matrix, 3))
    } else {
      cat("Need at least 2 numeric variables for correlation.")
    }
  })
  
  # Plot summary
  output$plotSummary <- renderPrint({
    df <- filteredData()
    req(df, input$xvar, input$yvar)
    
    if (is.numeric(df[[input$xvar]]) && is.numeric(df[[input$yvar]])) {
      cat("X Variable:", input$xvar, "\n")
      cat("Y Variable:", input$yvar, "\n")
      cat("Number of points:", nrow(df), "\n")
      cat("X range:", round(range(df[[input$xvar]], na.rm = TRUE), 2), "\n")
      cat("Y range:", round(range(df[[input$yvar]], na.rm = TRUE), 2), "\n")
    }
  })
  
  # Data summary
  output$dataSummary <- renderPrint({
    df <- filteredData()
    req(df)
    
    cat("Dataset dimensions:", dim(df), "\n")
    cat("\nColumn names:", paste(names(df), collapse = ", "), "\n")
    cat("\nData types:\n")
    print(sapply(df, class))
  })
  
  # Download handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("filtered-data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filteredData(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)