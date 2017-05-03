rm(list = ls())

library(R6)
library(shinydashboard)
library(shiny)
library(heemod)
library(shiny.router)

# own libraries 
source("R/utils.R")
source("R/app.root.R")

load("R/2state_mod.RData")
shinyApp(appRoot$ui(), appRoot$server())


