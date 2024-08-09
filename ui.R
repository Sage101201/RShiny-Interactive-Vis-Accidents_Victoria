library(shiny)
library(leaflet)

# Define UI for application
ui <- fixedPage(
  fluidRow(
    column(12, align = "center",
           div(style = "text-align: center;", titlePanel("Programming Exercise 2", windowTitle = "Programming Exercise 2"))
    )
  ),
  
  fluidRow(
    column(12, align = "center",
           div(style = "text-align: center;", tags$p("Name: Anish S"), tags$p("ID: 34113339")
               )
    )
  ),
  
  fluidRow(
    column(6,
           tags$h3("VIS 1"),
           plotOutput("vis1"),
           tags$h5("DESCRIPTION:"),
           tags$div(
             tags$p("This visualisation shows the count of accidents in different lighting conditions \
             and fraction of accidents occurring in the various speed zones in each of the different lighting conditions."),
           ),
           tags$h5("OBSERVATIONS:"),
           tags$div(
             tags$p("1. Most of the accidents occur during the Day time, which is nearly double the count of the rest put together."),
             tags$p("2. The most common speed zones where accidents occur is '50', '60', '80', '100'.")
           )
    ),
    column(6,
           tags$h3("VIS 2"),
           plotOutput("vis2"),
           tags$h5("DESCRIPTION:"),
           tags$div(
             tags$p("This visualisation shows the count of accidents in Victoria as per different hours of \
             the day, from 0 (12am) to 23 (11pm). It also displays the fraction of accidents occurring in the \
             top 4 idntified speed zones: 50, 60, 80, 100.")
           ),
           tags$h5("OBSERVATIONS:"),
           tags$div(
             tags$p("1. In nearly all hours of the day, the no. of accidents occuring in Speed Zone Limit-100 is \
             approximately half of the total count of accidents for the considered hour. This makes sense too, as \
             it's usually high speeds that people tend to lose control of their repsective vehicles and face accidents."),
             tags$p("2. Most of the accidents occur during 8am - 6pm which overlaps with regular human work travel patterns \
             of the day. People usually work 9-5 or similarly scheduled jobs and travel between work and home during this period. \
             Very few accidents happen in the 7pm - 7am period as this when people rest and are mostly holed up in their respective homes."),
             tags$p("3. The overall distribution of accidents in the course of a day gollows Normal or Gaussian Distribution, with \
             slight skewness to the left.")
           )
    )
  ),
  
  fluidRow(
    column(12,
           tags$h3("MAP"),
           leafletOutput("map")
    ),
    column(6,
           sliderInput("severity_range", "Severity Range:", min = 1, max = 3, value = c(1, 3))
    ),
    column(6,
           checkboxGroupInput("light_condition_filter", "Filter by Light Condition:",
                              choices = c("Day", "Dusk/Dawn", "Night"),
                              selected = c("Day", "Dusk/Dawn", "Night"))
    ),
    column(12,
           tags$h5("DECRIPTION:"),
           tags$div(
             tags$p("The map here shows the spread of accidents across the areas covered by these boundary locales: \
             Lang Lang, Grantville, San Remo, Philip Island, Wonthaggi & Inverloch. Each of the accidents is identified by a \
             circle marker of 3 colours, each representing the lighting condition at the accident: Yellow - Day (bright), Orange - \
             Dusk/Dawn (Less Light) and Red - Night (Very less Light)."),
             tags$p("It is to be noted that Red - Night denotes all times when the lighting conditions was dark/unkown at the accident scene i.e. \
                    the 4 Dark categories + 1 unkown category from the dataset (check VIS 1)."),
             tags$p("It's to be also noted that the size of each of circle markers correspond to the severity of the accident; bigger the \
             accident, bigger the circle corresponding to that accident."),
           ),
           tags$h5("OBSERVATIONS:"),
           tags$div(
             tags$p("1. Most of the highly severe accidents happen around night and day time/lighting conditions (red & yellow markers resp.; 12 each)."),
             tags$p("2. Generlly, most of the accidents occur during the day lighting conditions; since it is during this period (comparatively speaking) that most of road travel occurs."),
             tags$p("3. It's easy to gues the popular road travel routes in this area for these roads see most no. of accidents; e.g. the road connecting San Remo to Philip Island (Cowes), roads networking in \
             and around Wonthaggi and Inverloch respectively, roads running parallel to Western Port Coast etc.")
           )
    )
  ),
  
  fluidRow(
    column(12,
           tags$div(
             tags$h4("Data Sources and References:"),
             tags$div(tags$a("Colour Palette", href = "https://www.datanovia.com/en/blog/the-a-z-of-rcolorbrewer-palette/")),
             tags$div(tags$a("Static Maps", href = "https://www.datacamp.com/cheat-sheet/ggplot2-cheat-sheet")),
             tags$div(tags$a("Leaflet", href = "https://rstudio.github.io/leaflet/")),
             tags$div(tags$a("R Shiny", href = "https://mastering-shiny.org/"))
             )
    )
  )
)

