evol = EvolutionCohortComponent$new()
ui <- evol$view()
server <- function(input, output, session){
  callModule(evol$server(), evol$namespaceID(), session = session)
}
shinyApp(ui, server)