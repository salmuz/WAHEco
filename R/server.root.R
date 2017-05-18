#' Server Root Routes
#' 
#' This isclass save the namespace of all request servers (i.e. routes/servlet).
#' 
#' \code{set()}: 
#'        
#' \code{get()}: 
#' 
#' @export
#' 
ServerRoot <- R6Class(
  classname = "ServerRoot",
  private = list(server = NULL,
                 namespaceId = NULL),
  public = list(
    initialize = function(server, namespaceId) {
      self$set(server, namespaceId)
    },
    set = function(server, namespaceId) {
      private$server <- server
      private$namespaceId <- namespaceId
      invisible(self)
    },
    get = function() {
      list(server = private$server, nsi = private$namespaceId)
    }
  )
)