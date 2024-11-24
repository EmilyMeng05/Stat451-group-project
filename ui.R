library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Threatened Species Analysis (Stat 451)")

sidebar <- dashboardSidebar(
  
  sidebarMenu( id = "sidebarid",
    
    menuItem("General Overview",
             tabName = "genover",
             icon = icon("house", lib="font-awesome")
    
    )
  
  
  ),
  
  conditionalPanel(
    'input.sidebarid == "genover"',
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
  ),
  conditionalPanel(
    condition = "input.viewOption == 'trend'",
    checkboxGroupInput(
      inputId = "speciesType", 
      label = "Filter by Species Type", 
      choices = c("Total", "Vertebrates", "Invertebrates", "Plants"),
      selected = c("Total", "Vertebrates", "Invertebrates", "Plants") 
    )
  )
  
)

body <- dashboardBody(
  
  tabItems(
      
    tabItem( tabName = "genover",
      fluidRow(
        box(width=12,
            plotOutput("selectedGraph"))
      )
      
    )
  )
  
)
  
dashboardPage(header, sidebar, body)
