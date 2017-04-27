rm(list = ls())

library(R6)
library(shinydashboard)
library(shiny)
library(heemod)
library(shiny.router)

# own libraries 
source("R/utils.R")
source("R/app.root.R")

source("data/draft_med_eco.R")
shinyApp(appRoot$ui(), appRoot$server())




