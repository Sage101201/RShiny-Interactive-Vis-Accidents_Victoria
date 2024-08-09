# import libraries
library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)
library(RColorBrewer)

# read dataset and customize the dataframe as needed 
file_path <- "Victoria_Accident_Data_FIT5147S12024PE2v2.csv"
data <- read.csv(file_path)
data$ACCIDENT_TIME <- as.POSIXct(data$ACCIDENT_TIME, format = "%H.%M.%S") # convert to hour-min-sec format
data$HOUR <- hour(data$ACCIDENT_TIME)

# Define server logic
server <- function(input, output) {
  # Fill output$vis1 
  output$vis1 <- renderPlot({
    ggplot(data, aes(x = LIGHT_CONDITION_DESC, fill = as.factor(SPEED_ZONE))) +
      geom_bar(position = "stack") +
      labs(title = "Accidents by Light Condition and Speed Zone") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + # Adjust the angle of x-axis labels
      scale_fill_brewer(palette = "RdYlGn", direction = -1)
  })
  
  # Calculate top 4 speed zones from output$vis1
  top_speed_zones <- data %>%
    group_by(SPEED_ZONE) %>%
    summarise(Count = n()) %>%
    arrange(desc(Count)) %>%
    head(4) %>%
    .$SPEED_ZONE
  
  # Fill output$vis2 based on top 4 speed zones
  output$vis2 <- renderPlot({
    vis2_data <- data[data$SPEED_ZONE %in% top_speed_zones, ]
    
    ggplot(vis2_data, aes(x = HOUR, fill = as.factor(SPEED_ZONE))) +
      geom_bar(position = "stack") +
      labs(title = "Accidents by Hour and Speed Zone (Top 4)") +
      theme_minimal() +
      scale_fill_brewer(palette = "OrRd")
  })
  
  # Define the view and structure of the map using leaflet 
  output$map <- renderLeaflet({
    leaflet(data) %>%
      # fixing the map to certain position as per specification
      setView(lng = 145.465783, lat = -38.482461, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        # marker size as per severity 
        radius = ~(1/SEVERITY_RANK) * 6,
        # mapping color to lighting conditions
        color = ~ifelse(LIGHT_CONDITION_DESC == "Day", "yellow",
                        ifelse(LIGHT_CONDITION_DESC == "Dusk/Dawn", "orange", "red")),
        fillOpacity = 0.5,
        stroke = FALSE,
        # tooltip
        popup = ~paste("Date:", ACCIDENT_DATE, "<br>",
                       "Type:", ACCIDENT_TYPE_DESC, "<br>",
                       "Light Condition:", LIGHT_CONDITION_DESC, "<br>",
                       "Road Geometry:", ROAD_GEOMETRY_DESC, "<br>",
                       "Speed Zone:", SPEED_ZONE)
      ) %>%
      # Legend
      addLegend("bottomright", colors = c("yellow", "orange", "red"),
                labels = c("Day", "Dusk/Dawn", "Night"), title = "Light Condition")
    
  })
  
  # adding interactivity to the map
  observe({
    # severity range bar management
    filtered_data <- data[data$SEVERITY_RANK >= input$severity_range[1] &
                            data$SEVERITY_RANK <= input$severity_range[2],]
    
    selected_conditions <- input$light_condition_filter
    
    # lighting conditions check box management
    if (length(selected_conditions) > 0) {
      checked_data <- data.frame() # Initialize an empty data frame to store filtered data
      if ("Day" %in% selected_conditions) {
        checked_data <- rbind(checked_data, filtered_data[filtered_data$LIGHT_CONDITION_DESC == "Day", ])
      }
      if ("Dusk/Dawn" %in% selected_conditions) {
        checked_data <- rbind(checked_data, filtered_data[filtered_data$LIGHT_CONDITION_DESC == "Dusk/Dawn", ])
      }
      if ("Night" %in% selected_conditions) {
        checked_data <- rbind(checked_data, filtered_data[!filtered_data$LIGHT_CONDITION_DESC %in% c("Day", "Dusk/Dawn"), ])
      }
    } else {
      checked_data <- filtered_data[0, ] # Empty data frame
    }
    
    # showing input changes on the map
    leafletProxy("map") %>%
      clearMarkers() %>%
      addCircleMarkers(
        data = checked_data,
        radius = ~(1/SEVERITY_RANK) * 6, 
        color = ~ifelse(LIGHT_CONDITION_DESC == "Day", "yellow",
                        ifelse(LIGHT_CONDITION_DESC == "Dusk/Dawn", "orange", "red")),
        fillOpacity = 0.5,
        stroke = FALSE,
        # tooltip
        popup = ~paste("Date:", ACCIDENT_DATE, "<br>",
                       "Type:", ACCIDENT_TYPE_DESC, "<br>",
                       "Light Condition:", LIGHT_CONDITION_DESC, "<br>",
                       "Road Geometry:", ROAD_GEOMETRY_DESC, "<br>",
                       "Speed Zone:", SPEED_ZONE)
      )
  })
}
