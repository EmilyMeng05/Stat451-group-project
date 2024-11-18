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
      
      # Conditional Panel for the checker to appear only for the first graph
      conditionalPanel(
        condition = "input.viewOption == 'trend'",
        checkboxGroupInput(
          inputId = "speciesType", 
          label = "Filter by Species Type", 
          choices = c("Total", "Vertebrates", "Invertebrates", "Plants"),
          selected = c("Total", "Vertebrates", "Invertebrates", "Plants") 
        )
      )
    ),
    
    mainPanel(
      h3("Visualization"),
      uiOutput("dynamicTitle"),
      plotOutput("selectedGraph") 
    )
  )
)
