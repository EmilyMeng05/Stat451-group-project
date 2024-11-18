library(leaflet)
library(DT)

load("endangeredFinal.RData")

fluidPage(
  titlePanel("Stats 451 example"),
  
  sidebarLayout(
    
   
    sidebarPanel(
      radioButtons(
        inputId = "viewOption",
        label = "Choose the view:",
        choices = list(
          "Overall Trend for Species Changing" = "trend",
          "Top 5 Countries with the Highest Total Amount of Threatened Species" = "top5",
          "Top 5 Countries trend for Species Changing" = "5trend",
          "Highest Lost of Life" = "lost",
          "Average Number Across the World" = "average"
        ),
        selected = "trend"
      )
    ),
    
    mainPanel(
      h3("Dynamic Visualization"),
      uiOutput("dynamicTitle"),
      plotOutput("selectedGraph") 
    )
    
  )
)
