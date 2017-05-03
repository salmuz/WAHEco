library(R6)
library(shinydashboard)
library(shiny)
library(heemod)
library(shiny.router)

# own libraries 
setwd(dir = "../../")
source("R/utils.R")
source("R/app.root.R")

load("R/2state_mod.RData", envir = .GlobalEnv)

shinyUI(appRoot$ui())
