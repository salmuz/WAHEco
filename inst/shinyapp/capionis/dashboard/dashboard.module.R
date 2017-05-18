source("dashboard/plot.mtransition.R")
source("dashboard/plot.evolution-cohort.R")
source("dashboard/plot.psa-model.R")
source("dashboard/plot.dsa-model.R")

#' Dashboard Module 
#' 
#' Adding the modules customized (manually for the user)
#' The user should add the customized modules
#' 
DashboardModule = R6Class(
  classname = "DashboardModule", 
  inherit = WeMeco::SimpleModule,
  public = list(
    initialize = function(){
      super$initialize("/", "Capionis Web Application", 
                       icon = "dashboard", nameItem = "Dashboard")
    }
  )
)

# Components for module Dashboard
pl.graph <- GraphComponent$new()
pl.evolution <- EvolutionCohortComponent$new()
pl.psa <- PSAComponent$new()
pl.dsa <- DSAComponent$new()

dashboard <- DashboardModule$new()
dashboard$addComponent(pl.graph)
dashboard$addComponent(pl.evolution)
dashboard$addComponent(pl.psa)
dashboard$addComponent(pl.dsa)


