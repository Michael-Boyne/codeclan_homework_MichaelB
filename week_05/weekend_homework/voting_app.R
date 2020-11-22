library(readr)
library(ggplot2)
library(dplyr)
library(shiny)
library(maps)

voting_results <- read_csv("clean_data/general_election_results.csv")

all_constituencies <- unique(voting_results$constituency)

ui <- fluidPage(
  
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

server <- function(input, output) { 
  
  output$election_results <- renderPlot({
    
    voting_results %>%
      filter(constituency == input$constituency) %>%
      ggplot() +
        aes(x = party, y = vote_count) +
        geom_col(fill = case_when(input$constituency == "snp_votes" ~ "#ffff33",
                                  input$constituency == "lab_votes" ~ "#ff471a",
                                  input$constituency == "con_votes" ~ "#3333ff",
                                  input$constituency == "ld_votes" ~ "#ff9900",
                                  input$constituency == "grn_votes" ~ "#00b33c",
                                  input$constituency == "brex_votes" ~ "#00cccc",
                                  input$constituency == "ukip_votes" ~ "#9933ff",
                                  input$constituency == "oth_votes" ~ "#8c8c8c"))
    
  })
}

shinyApp(ui = ui, server = server)