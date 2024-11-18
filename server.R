library(shiny)
library(dplyr)
library(forcats)
library(readr)
library(corrplot)
library(tidyverse)
library(stringr)

shinyServer(function(input, output) {
  
  df <- df %>%
    rename(CountryName = 2) %>%
    mutate(SpeciesType = 
             unlist(str_extract_all(Series, '(?<=:\\s).*(?=\\s\\()')))
  
  output$selectedGraph <- renderPlot({
    if (input$viewOption == "trend") {
      # Plot for "Overall Trend"
      ggplot(df, aes(x = Year, y = Value, color = SpeciesType)) +
        geom_line() +
        labs(title = "Overall Trend of Threatened Species Over Time",
             x = "Year",
             y = "Number of Threatened Species") +
        theme_minimal()
    } else if (input$viewOption == "top5") {
      # Data for "Top 5 Countries"
      df_country_total_top <- df %>%
        filter(SpeciesType == "Total", !is.na(Value)) %>%
        group_by(CountryName) %>%
        summarize(TotalThreatened = sum(Value, na.rm = TRUE)) %>%
        arrange(desc(TotalThreatened)) %>%
        slice_head(n = 5)
      
      # Plot for "Top 5 Countries"
      ggplot(df_country_total_top, aes(x = fct_reorder(CountryName, TotalThreatened), y = TotalThreatened)) +
        geom_bar(stat = "identity", fill = "coral") +
        geom_text(aes(label = TotalThreatened),
                  position = position_dodge(width = 0.9),
                  hjust = -0.2,
                  color = "black",
                  size = 3) +
        labs(title = "Top 5 Countries with the Highest Total Amount of Threatened Species",
             x = "Country",
             y = "Total Amount of Threatened Species") +
        coord_flip() +
        theme_minimal()
    }else if (input$viewOption == "5trend") {
      # code needed
      ggplot() + labs(title = "Feature under development")
    } else if (input$viewOption == "lost") {
      # code ndeede
      ggplot() + labs(title = "Feature under development")
    } else if (input$viewOption == "average") {
      # coded needed
      ggplot() + labs(title = "Feature under development")
    }
    
  })
})
