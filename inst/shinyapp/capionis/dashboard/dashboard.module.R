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
  inherit = WAHEco::SimpleModule,
  public = list(
    initialize = function(){
      super$initialize("/", "Evaluation Coût-Efficacité", 
            content =  tagList( 
              tags$hr(),
              tags$h2("Drug-eluting stents V.S. Bare-metal stents"),
              tags$div(style = 'text-align:center', tags$img(src="images/stents_cas.png"))
              ),
            icon = "dashboard", nameItem = "Dashboard")
    }
  )
)

# Components for module Dashboard
pl.evolution <- EvolutionCohortComponent$new()
pl.psa <- PSAComponent$new()
pl.dsa <- DSAComponent$new()

dashboard <- DashboardModule$new()
dashboard$addComponent(pl.evolution)
dashboard$addComponent(pl.psa)
dashboard$addComponent(pl.dsa)


