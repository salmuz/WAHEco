#' Adding the base code for web application structure 
source("R/pages.root.R")

#' Adding the modules customized 
source('R/dashboard/dashboard.module.R')

AppRoot <- R6Class("AppRoot", 
    public = list(
      initialize = function(title = "Default App"){
        private$title = title
      },
      ui = function(){
        dashboardPage(
          dashboardHeader(title = private$title),
          dashboardSidebar(sidebarMenu(private$sidebars)),
          dashboardBody(router_ui())
        )
      },
      #' For printing the logs into server
      #' #  cat(file=stderr(), "<message>")
      server = function(){
        routerRoot <- make_router(
            private$routes
        )
        # Cleaner at context level
        # wrapperServer <- lapply(private$servers, function(x) match.call(callModule, 
        #             call("callModule", x$get()$server(), x$get()$nsi)))
        # lapply(wrapperServer, function(x) eval(x))
        function(input, output, session) {
          routerRoot(input, output)
          lapply(private$servers, function(x) do.call("callModule", list(x$get()$server, x$get()$nsi)))
        }
      },
      #' One improve on the list routes/servers is the copy by reference!!! @salmuz
      addModule = function (module = AppModule$new()){
        private$sidebars[[length(private$sidebars) + 1]] <- module$sidebar()
        private$routes <- c(private$routes, module$routes())
        private$servers <- c(private$servers, module$servers())
      }
    ),
    private = list(
      title = NULL,
      routes = list(),
      sidebars = list(),
      servers = list()
    )
)

# add each module or sub-module at main application
appRoot <- AppRoot$new("Capionis Demo")
appRoot$addModule(dashboard)



