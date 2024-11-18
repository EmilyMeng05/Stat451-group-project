library(shiny)

fluidPage(
  
  titlePanel("Threatened Species Analysis (Stats 451)"),
  
  sidebarLayout(
    
    sidebarPanel(
      radioButtons(
        inputId = "viewOption",
        label = "What question are you looking for?:",
        choices = list(
          "Overall Trend for Species Changing" = "trend",
          "Top 5 Countries with the Highest Total Amount of Threatened Species" = "top5",
          "Top 5 Countries trend for Species Changing" = "5trend",
          "Highest Lost of Life Graph" = "lost",
          "Average Number Across the World" = "average"
        ),
        selected = "trend"
      ),
      
      # Add a checkbox for Species Type
      checkboxGroupInput(
        inputId = "speciesType", 
        label = "Filter by Species Type", 
        choices = c("Total", "Vertebrates", "Invertebrates", "Plants"),
        selected = c("Total", "Vertebrates", "Invertebrates", "Plants")  # Default to all species types
      )
    ),
    
    mainPanel(
      h3("Visualization graph"),
      uiOutput("dynamicTitle"),
      plotOutput("selectedGraph") 
    )
  )
)
