library(readr)
library(ggplot2)
library(dplyr)
library(shiny)


voting_results <- read_csv("clean_data/general_election_results.csv")

all_constituencies <- unique(voting_results$constituency)

ui <- dashboardPage(dashboardHeader(), dashboardSidebar(), dashboardBody())
  
  sidebarLayout(
    sidebarPanel(
      selectInput("constituency",
                  "Choose Constituency",
                  choices = all_constituencies
      )
    ),
    mainPanel(
      plotOutput("election_results")
    )
  )
)


shinyApp(ui = ui, server = server)