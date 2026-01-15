# README.R
# ==============================================================================
# SHINY DATA EXPLORER DASHBOARD
# ==============================================================================

#' Title: Interactive Data Explorer Dashboard
#' Author: [Your Name/Organization]
#' Date: [Date]
#' Version: 1.0.0
#' License: MIT

# ==============================================================================
# OVERVIEW
# ==============================================================================

#' This Shiny application provides an interactive dashboard for exploring
#' and visualizing datasets. Users can upload their own CSV files or work
#' with built-in sample datasets, create customized plots, view data tables,
#' and generate summary statistics.

# ==============================================================================
# FEATURES
# ==============================================================================

#' ## Key Features:
#' 1. **Data Import**: Upload CSV files or select from sample datasets
#' 2. **Interactive Visualization**: Customizable scatter plots with ggplot2
#' 3. **Data Table**: Interactive DT table with search and pagination
#' 4. **Statistics**: Summary statistics and correlation matrices
#' 5. **Dynamic UI**: Variable selection updates based on loaded data
#' 6. **Data Export**: Download filtered data as CSV
#' 7. **Responsive Design**: Clean sidebar layout with tabbed interface

# ==============================================================================
# INSTALLATION
# ==============================================================================

#' ## Prerequisites:
#' 
#' Install R (>= 4.0.0) and RStudio from:
#'   - R: https://cran.r-project.org/
#'   - RStudio: https://posit.co/download/rstudio-desktop/
#'
#' ## Quick Start:
#' 
#' 1. Copy the `app.R` file to your working directory
#' 2. Install required packages:
#'

# Install required packages
required_packages <- c("shiny", "ggplot2", "DT")

# Check and install missing packages
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Uncomment to install packages:
# lapply(required_packages, install_if_missing)

# ==============================================================================
# RUNNING THE APPLICATION
# ==============================================================================

#' ## Running the App:
#' 
#' ### Option 1: In RStudio
#' 1. Open `app.R` in RStudio
#' 2. Click the "Run App" button (top-right of source pane)
#' 3. Or press Ctrl+Shift+Enter (Windows/Linux) or Cmd+Shift+Return (Mac)
#' 
#' ### Option 2: From R Console
#'

# Run from console (if app.R is in working directory)
# shiny::runApp("app.R")

# Or run directly:
# shiny::runApp()

# ==============================================================================
# APP STRUCTURE
# ==============================================================================

#' ## File Structure:
#' ```
#' project-folder/
#' ├── app.R              # Main Shiny application
#' ├── README.R          # This documentation file
#' ├── data/             # Optional: folder for data files
#' │   ├── sample.csv
#' │   └── your_data.csv
#' ├── www/              # Optional: for static assets
#' │   ├── style.css
#' │   └── images/
#' └── tests/            # Optional: for test files
#' ```

# ==============================================================================
# USING THE APPLICATION
# ==============================================================================

#' ## Step-by-Step Guide:
#' 
#' ### 1. Launch the App
#' - Run the app using one of the methods above
#' - A browser window will open with the dashboard
#' 
#' ### 2. Load Data
#' - **Option A**: Click "Browse..." to upload a CSV file
#' - **Option B**: Select a sample dataset from the dropdown
#' 
#' ### 3. Create Visualizations
#' - Choose variables for X and Y axes from dropdowns
#' - Adjust point size with the slider
#' - Select a plot theme
#' - Check "Add trend line" for regression line
#' - Click "Update Dashboard" to apply changes
#' 
#' ### 4. Explore Data
#' - Switch between tabs:
#'   - **Plot**: View and customize visualizations
#'   - **Data Table**: Browse/search the data
#'   - **Statistics**: View summaries and correlations
#'   - **About**: App documentation
#' 
#' ### 5. Export Data
#' - Use the "Download Filtered Data" button to save CSV

# ==============================================================================
# SAMPLE DATASETS
# ==============================================================================

#' ## Included Datasets:
#' 
#' 1. **mtcars** - Motor Trend car road tests (32 × 11)
#'    - Variables: mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb
#' 
#' 2. **iris** - Edgar Anderson's iris data (150 × 5)
#'    - Variables: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species
#' 
#' 3. **diamonds** - Diamond prices (53,940 × 10)
#'    - Variables: carat, cut, color, clarity, depth, table, price, x, y, z
#' 
#' 4. **mpg** - Fuel economy data (234 × 11)
#'    - Variables: manufacturer, model, displ, year, cyl, trans, drv, cty, hwy, fl, class

# ==============================================================================
# CUSTOMIZATION
# ==============================================================================

#' ## How to Customize:
#' 
#' ### 1. Add New Sample Dataset:
#'

# In app.R, modify the observeEvent(input$dataset, ...) section:
add_dataset_example <- function() {
  # Example: Add your own dataset
  # In the switch() statement, add:
  # "your_data" = your_dataframe,
  
  # And in the UI selectInput, add:
  # choices = c("mtcars", "iris", "diamonds", "mpg", "your_data"),
}

#' ### 2. Change Default Plot Type:
#'

# To add histogram/boxplot options:
add_plot_types <- function() {
  # 1. Add radioButtons to UI:
  # radioButtons("plotType", "Plot type:",
  #              choices = c("Scatter", "Histogram", "Boxplot"),
  #              selected = "Scatter")
  
  # 2. Modify renderPlot() to use input$plotType
}

#' ### 3. Add More Statistics:
#'

# In the Statistics tab, you can add:
add_statistics <- function() {
  # - Regression models
  # - Hypothesis tests
  # - Distribution fitting
  # - Time series analysis
}

# ==============================================================================
# DATA FORMAT REQUIREMENTS
# ==============================================================================

#' ## CSV File Requirements:
#' - File extension: .csv or .txt
#' - First row should contain column names
#' - Comma-separated values (or adjust read.csv() parameters)
#' - Missing values should be empty or NA
#' - For best results with plotting, include numeric columns

# Example of a properly formatted CSV:
example_data <- data.frame(
  ID = 1:10,
  Value = rnorm(10),
  Category = sample(c("A", "B", "C"), 10, replace = TRUE),
  Date = seq.Date(Sys.Date(), by = "day", length.out = 10)
)

# Write example CSV (uncomment to create):
# write.csv(example_data, "data/example_format.csv", row.names = FALSE)

# ==============================================================================
# TROUBLESHOOTING
# ==============================================================================

#' ## Common Issues:
#' 
#' ### 1. "Package not found" error
#' - Run: install.packages(c("shiny", "ggplot2", "DT"))
#' - Restart R session
#' 
#' ### 2. CSV file won't upload
#' - Check file is actually CSV format
#' - Ensure file size < 5MB (adjust limits in fileInput)
#' - Check for special characters in column names
#' 
#' ### 3. Plot doesn't update
#' - Click "Update Dashboard" button
#' - Ensure numeric variables are selected
#' - Check R console for error messages
#' 
#' ### 4. App runs but browser doesn't open
#' - Check browser isn't blocking popups
#' - Access manually at: http://127.0.0.1:XXXX
#' - Check RStudio Viewer pane

# ==============================================================================
# DEPENDENCIES
# ==============================================================================

#' ## Package Dependencies:
dependencies <- list(
  shiny = "Web application framework",
  ggplot2 = "Data visualization",
  DT = "Interactive data tables",
  dplyr = "Data manipulation (optional, for extensions)",
  tidyr = "Data tidying (optional, for extensions)",
  plotly = "Interactive plots (optional, for extensions)"
)

# Check installed packages
check_dependencies <- function() {
  cat("Checking dependencies...\n")
  for (pkg in names(dependencies)) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      cat(sprintf("✓ %s: %s\n", pkg, dependencies[[pkg]]))
    } else {
      cat(sprintf("✗ %s: NOT INSTALLED (%s)\n", pkg, dependencies[[pkg]]))
    }
  }
}

# Uncomment to check:
# check_dependencies()

# ==============================================================================
# EXTENDING THE APP
# ==============================================================================

#' ## Ideas for Extensions:
#' 
#' 1. **Add Machine Learning**
#'   - Regression/classification models
#'   - Model performance metrics
#'   - Prediction interface
#' 
#' 2. **Additional Visualizations**
#'   - Time series plots
#'   - Heatmaps
#'   - Network graphs
#' 
#' 3. **Data Processing**
#'   - Data cleaning tools
#'   - Variable transformation
#'   - Missing value imputation
#' 
#' 4. **Report Generation**
#'   - PDF/HTML reports
#'   - Automated summaries
#'   - Export plots to images

# ==============================================================================
# CONTRIBUTING
# ==============================================================================

#' ## How to Contribute:
#' 
#' 1. Fork the repository
#' 2. Create a feature branch
#' 3. Make your changes
#' 4. Test thoroughly
#' 5. Submit a pull request
#' 
#' ## Code Style:
#' - Use consistent indentation (2 spaces)
#' - Comment complex logic
#' - Follow tidyverse style guide where applicable
#' - Use meaningful variable names

# ==============================================================================
# LICENSE AND CITATION
# ==============================================================================

#' ## License:
#' MIT License - See LICENSE file for details
#' 
#' ## Citation:
#' If you use this app in research, please cite:
#' [Your preferred citation format]
#' 
#' ## Acknowledgments:
#' - R Core Team
#' - Shiny developers
#' - Tidyverse team
#' - CRAN maintainers

# ==============================================================================
# GETTING HELP
# ==============================================================================

#' ## Support:
#' - RStudio Community: https://community.rstudio.com
#' - Stack Overflow (tag: r, shiny)
#' - GitHub Issues: [Your repo link]
#' 
#' ## Documentation Links:
#' - Shiny: https://shiny.posit.co/
#' - ggplot2: https://ggplot2.tidyverse.org/
#' - DT: https://rstudio.github.io/DT/

# ==============================================================================
# VERSION HISTORY
# ==============================================================================

#' ## Changelog:
#' 
#' ### v1.0.0 [Date]
#' - Initial release
#' - Basic data upload and visualization
#' - Interactive data table
#' - Summary statistics
#' - Sidebar layout with tabs
#' 
#' ### v1.1.0 [Planned]
#' - Add more plot types
#' - Data preprocessing tools
#' - User authentication
#' - Theming options

# ==============================================================================
# END OF README
# ==============================================================================

cat("\n")
cat("=======================================================================\n")
cat("Shiny Data Explorer Dashboard README\n")
cat("=======================================================================\n")
cat("To use this app:\n")
cat("1. Ensure all packages are installed\n")
cat("2. Run: shiny::runApp('app.R')\n")
cat("3. Open browser to: http://127.0.0.1:PORT\n")
cat("=======================================================================\n")