library(shinydashboard)
library(shiny)
library(shinyAce)
library(heemod)
library(WeMeco)

# loading default data test 
load(system.file("extdata", "mortalityData.RData", package="WeMeco"))

source('utils.R')
source('dashboard/dashboard.module.R')
source('setting/setting.module.R')


# Add each module to main application web Capionis 
appRoot <- AppRoot$new("Capionis ME")
appRoot$addModule(dashboard)
appRoot$addModule(setting)

# Load data
# load("../../extdata/2state_mod.RData", envir = .GlobalEnv)