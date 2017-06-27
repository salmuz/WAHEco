#' Application Root Container
#' 
#' This class is the main web container which contains of sub-modules, 
#' it has four main methods [AppRoot$initialize()], [AppRoot$server()] 
#' [AppRoot$ui()] and [AppRoot$addModule()].
#' 
#' \code{ui()}: it create the main web interface with routes of 
#'        sub-modules injected.
#'        
#' \code{server()}: it create the main server (container of servers)
#'       in order to responds all http request.
#'       
#' \code{addModule(module)}: add new modules to container main web, 
#' param module is a class module that has server, siderbars and routes
#' 
#' @export
#' 
AppRoot <- R6Class("AppRoot", 
    public = list(
      initialize = function(title = "Default App"){
        private$title = title
      },
      
      ui = function(){
        dashboardPage(
          dashboardHeader(title = private$title),
          dashboardSidebar(sidebarMenu(private$sidebars)),
          dashboardBody(shiny.router::router_ui())
        )
      },
      
      # For printing the logs into server
      #    cat(file=stderr(), "<message>")
      #
      # Another option : Cleaner at context level
      #    wrapperServer <- lapply(private$servers, function(x) match.call(callModule, 
      #             call("callModule", x$get()$server(), x$get()$nsi)))
      #    lapply(wrapperServer, function(x) eval(x))
      #    
      server = function(){
        if(length(private$routes) > 0)
          routerRoot <- make_router(private$routes)
        else
          routerRoot <- make_router(list('/' = ViewFactory$new()$createContent('AppRoot')))
        
        function(input, output, session) {
          routerRoot(input, output)
          if(length(private$servers))
            lapply(private$servers, function(x) 
              do.call("callModule", list(x$get()$server, x$get()$nsi, session=session)))
        }
      },
      
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



