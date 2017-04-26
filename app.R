#rm(list = ls())

library(shinydashboard)
library(shiny)
library(heemod)
library(shiny.router)

# App Commponents 
source("R/pages.root.R",  chdir = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "Capionis Demo"),
  dashboardSidebar(pl.root.slider),
  dashboardBody(pl.root.body)
)

server <- function(input, output, session) {
  router(input, output)
  callModule(graphTrans.server, graph.NAMESPACE_ID)
  callModule(survival.server, survival.NAMESPACE_ID)
}

## Cas of example for plotting the graphics 
source("../examples/draft_med_eco.R")

shinyApp(ui, server)


