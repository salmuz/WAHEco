#' Adding the structure base code for web application architecture  
source("R/pages.root.R")

#' Adding the modules customized (manually for the user)
#' @description  the user should add the customized modules
source('R/dashboard/dashboard.module.R')

#' This class is the main web container of sub-modules 
#' It has three main methods 
#'   @method  ui: it create the main web interface with routes of 
#'        sub-modules injected.
#'   @method server: it create the main server (container of servers)
#'       in order to responds all http request.
#'   @method  addModule : add new modules to container main web.
#'   
AppRoot <- R6Class("AppRoot", 
    public = list(
      initialize = function(title = "Default App"){
        private$title = title
      },
      
      #'
      #' @return the content web interface
      ui = function(){
        dashboardPage(
          dashboardHeader(title = private$title),
          dashboardSidebar(sidebarMenu(private$sidebars)),
          dashboardBody(router_ui())
        )
      },
      
      #' For printing the logs into server
      #'    cat(file=stderr(), "<message>")
      #' 
      #' Another option : Cleaner at context level
      #'    wrapperServer <- lapply(private$servers, function(x) match.call(callModule, 
      #'             call("callModule", x$get()$server(), x$get()$nsi)))
      #'    lapply(wrapperServer, function(x) eval(x))
      #'    
      #'  @return the main container server
      server = function(){
        routerRoot <- make_router(
            private$routes
        )
        
        function(input, output, session) {
          routerRoot(input, output)
          lapply(private$servers, function(x) 
            do.call("callModule", list(x$get()$server, x$get()$nsi, session=session)))
        }
      },
      
      #' One improve on the list routes/servers is the copy by reference!!! @salmuz
      #' @param module a class module that has server, siderbars and routes
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



