#' Adding the components customized 
source("R/dashboard/plot.mtransition.R")
source("R/dashboard/plot.evolution-cohort.R")
source("R/dashboard/plot.psa-model.R")
source("R/dashboard/plot.dsa-model.R")

DashboardModule = R6Class(
  classname = "Dashboard", 
  inherit = AppModule,
  public = list(
    initialize = function(){
      private$routes[["/"]] <- private$viewFactory$createContent(title = "Capionis Web Application")
    },
    sidebar = function(){
      menuItem("Dashboard", icon = shiny::icon("dashboard"), private$items)
    },
    addComponent = function(component = AppComponent$new()){
      private$items[[length(private$items) + 1]] <- component$item()
      private$routes[[component$route()]] <- 
        private$viewFactory$createContent(title = component$title(), component$view())
      private$servers[[length(private$servers) + 1]] <- 
        ServerRoot$new(component$server(), component$namespaceID())
    }
  ),
  private = list(
    items = list(),
    routes = list(),
    servers = list(),
    viewFactory = ViewFactory$new()
  )
)

pl.graph <- GraphComponent$new()
pl.evolution <- EvolutionCohortComponent$new()
pl.psa <- PSAComponent$new()
pl.dsa <- DSAComponent$new()

dashboard <- DashboardModule$new()
dashboard$addComponent(pl.graph)
dashboard$addComponent(pl.evolution)
dashboard$addComponent(pl.psa)
dashboard$addComponent(pl.dsa)
