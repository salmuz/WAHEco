#' Web Component Application
#' 
#' This is abstract class to create a web component, 
#' it has five main methods [AppComponent$view()], [AppComponent$server()] 
#' [AppComponent$route()], [AppComponent$title()] and [AppComponent$namespaceID()].
#' 
#' \code{view()}: 
#'        
#' \code{server()}: 
#'       
#' \code{route()}: 
#' 
#' @export
#' 
AppComponent <- R6Class(
  classname = "AppComponent", 
  public = list(
    genNS = NULL,
    initialize = function(title = 'Component Default', path = "/default", nsid = "id-default"){
      private$TITLE <- title
      private$NAMESPACE_ID <- nsid
      private$ROUTE_PATH <- path
      self$genNS <- NS(private$NAMESPACE_ID)
    },
    view = function(...) stop("It's a abastract class."),
    server = function(...) stop("It's a abastract class."),
    route = function() private$ROUTE_PATH,
    namespaceID = function() private$NAMESPACE_ID,
    title = function() private$TITLE
  ), 
  private = list(
    ROUTE_PATH = NULL,
    NAMESPACE_ID = NULL,
    TITLE = NULL
  )
)