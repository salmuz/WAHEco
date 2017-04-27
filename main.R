#rm(list = ls())

library(R6)
library(shinydashboard)
library(shiny)
library(heemod)
library(shiny.router)

# own libraries 
source("R/utils.R", chdir = TRUE)
source("data/draft_med_eco.R")

source("R/app.root.R", chdir = TRUE)
shinyApp(appRoot$ui(), appRoot$server())

# source("R/pages.root.R", chdir = TRUE)
# ## Cas of example for plotting the graphics
# ui <- dashboardPage(
#   dashboardHeader(title = "sallala"),
#   dashboardSidebar(pl.root.slider),
#   dashboardBody(router_ui())
# )
# 
# shinyApp(ui, function(input, output, session) {
#   routerRoot(input, output)
#   callModule(graphTrans.server, graph.NAMESPACE_ID)
#   # callModule(survival.server, survival.NAMESPACE_ID)
# })




