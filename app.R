library(shiny)
library(bslib)
library(DT)

ui <- page_sidebar(
  title = "Installed R Packages",
  sidebar = sidebar(
    selectInput("sort_by", "Sort by",
      choices = c("Package Name" = "Package", "Version"),
      selected = "Package"
    ),
    checkboxInput("reverse", "Reverse order", FALSE)
  ),
  
  card(
    card_header("Installed Packages and Versions"),
    DT::dataTableOutput("packages_table")
  )
)

server <- function(input, output) {
  # Get installed packages data
  packages_data <- reactive({
    pkg_data <- as.data.frame(installed.packages()[, c("Package", "Version")])
    
    # Sort based on user selection
    if (input$reverse) {
      pkg_data[order(pkg_data[[input$sort_by]], decreasing = TRUE), ]
    } else {
      pkg_data[order(pkg_data[[input$sort_by]]), ]
    }
  })
  
  # Render the data table
  output$packages_table <- DT::renderDataTable({
    DT::datatable(
      packages_data(),
      options = list(
        pageLength = 15,
        searchHighlight = TRUE
      ),
      filter = "top"
    )
  })
}

shinyApp(ui, server)
