server <- function(input, output) { 
  
  output$election_results <- renderPlot({
    
    voting_results %>%
      filter(constituency == input$constituency) %>%
      ggplot() +
      aes(x = party, y = vote_count, fill = case_when(input$constituency == "snp_votes" ~ "#ffff33",
                                                      input$constituency == "lab_votes" ~ "#ff471a",
                                                      input$constituency == "con_votes" ~ "#3333ff",
                                                      input$constituency == "ld_votes" ~ "#ff9900",
                                                      input$constituency == "grn_votes" ~ "#00b33c",
                                                      input$constituency == "brex_votes" ~ "#00cccc",
                                                      input$constituency == "ukip_votes" ~ "#9933ff",
                                                      input$constituency == "oth_votes" ~ "#8c8c8c")) +
      geom_col()
    
  })
}