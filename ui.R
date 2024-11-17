library(leaflet)
library(DT)

load("endangeredFinal.RData")

fluidPage(
  titlePanel("Stats 451 example"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      
      selectInput("country",
                  "Select country",
                  distinct(endangered, endangered$`Region/Country/Area`),
                  "United States of America"
      )
      
    ),
    
    mainPanel()
    
  )
)
