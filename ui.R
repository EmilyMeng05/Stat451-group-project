library(shiny)
library(shinydashboard)

df <- read_csv("UN_threatened_species.csv", skip=1)

df <- df %>%
  rename(CountryName = 2) %>%
  mutate(SpeciesType = 
           unlist(str_extract_all(Series, '(?<=:\\s).*(?=\\s\\()')))
df$CountryName <- iconv(df$CountryName, to = "UTF-8", sub = "")
countries <- unique(df$CountryName)


header <- dashboardHeader(title = "Threatened Species Analysis (Stat 451)")

sidebar <- dashboardSidebar(
  
  sidebarMenu( id = "sidebarid",
    
    menuItem("General Overview",
             tabName = "genover",
             icon = icon("house", lib="font-awesome")
    
    ),
    
    menuItem("By Country",
             tabName = "country",
             icon = icon("globe"))
  
  
  ),
  
  conditionalPanel(
    'input.sidebarid == "genover"',
      radioButtons(
        inputId = "viewOption",
        label = "What question are you looking for?:",
        choices = list(
          "Overall Trend for Species Changing" = "trend",
          "Top 5 Countries with the Highest Total Amount of Threatened Species" = "top5",
          "Countries With the Most Threatened Species (Top 5)" = "5trend",
          "Highest Lost of Life Graph" = "lost",
          "Average Number Across the World" = "average"
        ),
        selected = "trend"
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
  ),
  
  conditionalPanel(
    condition = 'input.sidebarid == "country"',
    selectInput(
      inputId = "countryOption",
      label = "Country",
      choices = countries
    )
  )
  
)

body <- dashboardBody(
  
  tabItems(
      
    tabItem( tabName = "genover",
      
      conditionalPanel(
        condition = 'input.viewOption == "lost"',
        
        fluidRow(
          infoBoxOutput(width = 6,
                        outputId = "infoYear"),
          infoBoxOutput(width = 6,
                        "infoAmt")
        )
      ),       
             
      fluidRow(
        box(width=12,
            plotOutput("selectedGraph"))
      )
      
    ),
    tabItem(
      tabName = "country",
      fluidRow(
        box(width = 12,
            plotOutput("countryPlot"))
      )
      
    )
    
  )
  
)
  
dashboardPage(header, sidebar, body)
