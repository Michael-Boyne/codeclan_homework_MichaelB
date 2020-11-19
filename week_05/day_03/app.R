library(tidyverse)
library(shiny)
library(shinythemes)

olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv")

all_teams <- unique(olympics_overall_medals$team)
all_seasons <- unique(olympics_overall_medals$season)
all_medals <- unique(olympics_overall_medals$medal)

ui <- fluidPage(
  
  theme = shinytheme("superhero"),

  titlePanel(tags$h2("Top 10 teams at the Olympics")), 
  
  tabsetPanel(
      tabPanel("1 - 5th",
              sidebarLayout(
                sidebarPanel(
                  radioButtons(
                    inputId = "season",
                    label = tags$h4("Summer or Winter Olympics?"),
                    choices = all_seasons
                  ),
                  radioButtons(
                    inputId = "medal",
                    label = tags$h4("Medal"),
                    choices = all_medals
                  )
                ),
                mainPanel(
                  plotOutput(outputId = "medal_plot")
                )
               )
      ),
     
      tabPanel("6 - 10th",
               sidebarLayout(
                 sidebarPanel(
                   radioButtons(
                     inputId = "season",
                     label = tags$h4("Summer or Winter Olympics?"),
                     choices = all_seasons
                   ),
                   radioButtons(
                     inputId = "medal",
                     label = tags$h4("Medal"),
                     choices = all_medals
                   )
                 ),
                 mainPanel(
                   plotOutput(outputId = "medal_plot_two")
                 )
               )
      ),
      
  
      tabPanel("Olympic Website",
                tags$a(hrep = "https://www.olympic.org/", "Olympic Website")
      )
  )
)


server <- function(input, output) {
  output$medal_plot <- renderPlot({
    olympics_overall_medals %>%
      filter(team %in% c("United States",
                         "Soviet Union",
                         "Germany",
                         "Italy",
                         "Great Britain")) %>%
      filter(medal == input$medal) %>%
      filter(season == input$season) %>%
      ggplot() +
      aes(x = team, y = count) +
      geom_col(fill = case_when(input$medal == "Bronze" ~ "#e69900",
                                input$medal == "Silver" ~ "gray40",
                                input$medal == "Gold" ~ "gold"))
  })
}

server <- function(input, output) {
  output$medal_plot_two <- renderPlot({
    olympics_overall_medals %>%
      filter(team %in% c("Hungary",
                         "France",
                         "East Germany",
                         "Australia",
                         "Sweden")) %>%
      filter(medal == input$medal) %>%
      filter(season == input$season) %>%
      ggplot() +
      aes(x = team, y = count) +
      geom_col(fill = case_when(input$medal == "Bronze" ~ "#e69900",
                                input$medal == "Silver" ~ "gray40",
                                input$medal == "Gold" ~ "gold"))
  })
}

shinyApp(ui = ui, server = server)