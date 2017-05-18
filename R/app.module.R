#' Web Module Application
#' 
#' This is abstract class to create a web module, 
#' it has three main methods [AppModule$sidebar()], [AppModule$routes()] 
#' and [AppModule$servers()]
#' 
#' \code{view()}: 
#'        
#' \code{server()}: 
#'       
#' \code{route()}: 
#' 
#' @export
#' 
AppModule <- R6Class(
  classname = "AppModule",
  public = list(
    sidebar = function(...)
      stop("It's a abastract class."),
    routes = function(...)
      private$routes,
    servers = function(...)
      private$servers
  )
)

#' View Factory Life Cycle 
#' 
#' This is static class.
#' 
#' \code{createContent()}: 
#'         
#' @export
#' 
ViewFactory <- R6Class(
  classname = "ViewFactory",
  public = list(
    createContent = function(title = "Default Name", ...) {
      tagItems <- list(...)
      lapply(tagItems, tagAssert)
      tags$div(style = "margin-top : -20px", tags$h1(title), tagItems)
    }
  )
)

#' 
#' Simple Implementation Web Module Application
#' 
#' This is default simple implementation of AppModule class that create a web module component, 
#' it has three main methods [AppModule$sidebar()], [AppModule$routes()] 
#' and [AppModule$servers()]
#' 
#' \code{view()}: 
#'        
#' \code{server()}: 
#'       
#' \code{route()}: 
#' 
#' @export
#' 
SimpleModule = R6Class(
  classname = "SimpleModule", 
  inherit = AppModule,
  public = list(
    initialize = function(route = "/", title = "Default Simple Module", 
                          icon = "desktop", nameItem = "Default Module"){
      private$routes[[route]] <- private$viewFactory$createContent(title = title)
      private$.icon = icon
      private$.nameItem = nameItem
    },
    sidebar = function(){
      menuItem(private$.nameItem, icon = shiny::icon(private$.icon), private$items)
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
    viewFactory = ViewFactory$new(),
    .icon = NULL, 
    .nameItem = NULL
  )
)
