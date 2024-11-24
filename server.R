# library
library(shiny)
library(dplyr)
library(forcats)
library(readr)
library(corrplot)
library(tidyverse)
library(stringr)

function(input, output, session) {
  
  ## load dataset
  df <- read_csv("UN_threatened_species.csv", skip=1)
  
  df <- df %>%
    rename(CountryName = 2) %>%
    mutate(SpeciesType = 
             unlist(str_extract_all(Series, '(?<=:\\s).*(?=\\s\\()')))
  df$CountryName <- iconv(df$CountryName, to = "UTF-8", sub = "")
  
  output$selectedGraph <- renderPlot({
    # first graph
    if (input$viewOption == "trend") {
      df_filtered <- df %>%
        filter(SpeciesType %in% input$speciesType)
      
      df_total_species <- df_filtered %>%
        group_by(Year, SpeciesType) %>%
        summarize(TotalValue = sum(Value, na.rm = TRUE), .groups = 'drop')
      
      # the first graph code
      ggplot(df_total_species, aes(x = Year, y = TotalValue, color = SpeciesType)) +
        geom_line() +  
        labs(x = "Year", y = "Amount", title = "Total Number of Endangered Species Over the Years By Group") +
        theme_minimal() +
        theme(legend.title = element_blank()) + 
        scale_y_continuous(limits = c(0, 60000), breaks = seq(0, 40000, by = 10000)) +  # Zoom in on y-axis
        theme(legend.position = "right")
      
      
    } else if (input$viewOption == "top5") {
      # get the top 5
      df_country_total_top <- df %>%
        filter(SpeciesType == "Total", !is.na(Value)) %>%
        group_by(CountryName) %>%
        summarize(TotalThreatened = sum(Value, na.rm = TRUE)) %>%
        arrange(desc(TotalThreatened)) %>%
        slice_head(n = 5)
      
      # plot the graph
      ggplot(df_country_total_top, aes(x = fct_reorder(CountryName, TotalThreatened), y = TotalThreatened)) +
        geom_bar(stat = "identity", fill = "cornflowerblue") +
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
    } else if (input$viewOption == "5trend") {
      # List of top 5 countries
      top_5_countries <- c("Ecuador", "Madagascar", "United States of America","Indonesia", "Malaysia")
      
      # Filter to not include total and also only within top 5 country
      df_top_5_countries <- df %>%
        filter(SpeciesType %in% c("Vertebrate", "Invertebrate", "Plants"), 
               CountryName %in% top_5_countries, 
               !is.na(Value)) 
      
      # to make sure the legand are lined based on the order of 5 countries
      df_top_5_countries$CountryName <-
        factor(df_top_5_countries$CountryName,
               levels = top_5_countries)
      
      ggplot(df_top_5_countries, aes(x = Year, y = Value, color = CountryName, group = CountryName)) +
        geom_line() +
        geom_point() +
        labs(title = "Number of Threatened Species Over Time (Top 5 countries)",
             x = "Year",
             y = "Total amount of Threatened species value") +
        scale_x_continuous(breaks = unique(df_top_5_countries$Year)) +
        theme_minimal() +
        theme(legend.title = element_blank(), 
              legend.position = "right") 
    } else if (input$viewOption == "lost") {
      highest_loss <- df %>% 
        group_by(Year) %>% 
        mutate(total_loss = sum(Value))
      
      highest_loss %>% 
        ggplot(aes(x=Year, y=total_loss)) +
        geom_line(colour = "cornflowerblue") +
        labs(title = "Total loss of life throughout the years",
             x = "Count",
             y = "Year") +
        theme_minimal()
      
    } else if (input$viewOption == "average") {
      average_df <- df %>% 
        group_by(SpeciesType) %>% 
        group_by(Year) %>% 
        mutate(average = mean(Value))
      
      average_df %>% 
        ggplot(aes(x=Year, y = average)) +
        geom_line(colour = "cornflowerblue") +
        labs(title = "Average loss of life throughout the years",
             y = "Count") +
        theme_minimal()
    }
    
  })
  
  output$countryPlot <- renderPlot({
    
    df %>% 
      filter(CountryName == input$countryOption) %>% 
      ggplot(aes(x=Year, y=Value, group=Series, color=SpeciesType)) +
      geom_line() +
      labs(title = "Lost of life by Country and Type",
           y = "Count") +
      scale_fill_discrete(breaks=c('Total', 'Invertebrates', 'Vertebrates', 'Plants')) +
      theme_minimal()
    
  })
  
  output$infoYear = renderInfoBox({
    
    infoBox(
      "Year",
      max(highest_loss$Year),
      icon = icon("calendar"),
      color = "light-blue"
    )
  })
  output$infoAmt = renderInfoBox({
    
    infoBox(
      "Total Loss of Life",
      max(highest_loss$total_loss),
      icon = icon("book-skull", lib = "font-awesome"),
      color = "red"
    )
  })
}
