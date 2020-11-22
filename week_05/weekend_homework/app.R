library(readr)
library(ggplot2)
library(dplyr)
library(shiny)
library(shinythemes)

voting_results <- read_csv("clean_data/general_election_results.csv")

all_constituencies <- unique(voting_results$constituency)

ui <- fluidPage(

# "superhero" is a shiny theme I quite liked.  
    
  theme = shinytheme("superhero"),
  
  titlePanel("The 2019 General Election in Scotland - Results"),
  
  tabsetPanel(
    
    tabPanel("Constituencies",

             sidebarLayout(
    
              sidebarPanel(
     
                selectInput("constituency",
                            "Choose Constituency",
                            choices = all_constituencies
                )
          
# What I would have liked to have done here is added another sidebar slider 
# That would allow you to pick a party and all the constituencies that that
# party won, would show. However, I was unsuccessful with my lack of time to 
# work out how to achieve this.
          
              ),
   
              mainPanel(
     
                tabsetPanel(

# Three panels layout is quite nice, as it is clear what each panel does, and
# allows for quick access three difference visual ways of seeing the results in
# the selected constituency.
       
                  tabPanel("Graph",
                
                      plotOutput("election_results")
                  ),
                  tabPanel("Table",
                
                      dataTableOutput("vote")
                  ),
              )
           )
        )
    ),
    tabPanel("Full Results",
             
             
      
    )


server <- function(input, output) { 
  
  

  
  output$election_results <- renderPlot({
    
    voting_results %>%
      filter(constituency == input$constituency) %>%
      ggplot() +
      aes(x = party, y = vote_count, fill = party) +
      geom_col() +
      scale_fill_manual(
        values = c(
          "snp_votes" = "#ffff33",
          "con_votes" = "#3333ff",
          "ld_votes" = "#ff9900",
          "grn_votes" = "#00b33c",
          "lab_votes" = "#ff471a",
          "brex_votes" = "#00cccc",
          "ukip_votes" = "#9933ff",
          "oth_votes" = "#8c8c8c"
        )
      )
    
  })
  
  output$percentage <- 
  
  output$vote <- renderDataTable({
    voting_results()
  })
  
  
  
}


shinyApp(ui = ui, server = server)