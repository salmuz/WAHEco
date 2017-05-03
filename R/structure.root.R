ServerRoot <- R6Class("ServerRoot",
    private = list(
      server = NULL,
      namespaceId = NULL
    ),
    public = list(
      initialize = function(server, namespaceId){
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

AppModule <- R6Class(
  classname = "AppModule",
  public = list(
    sidebar = function(...) stop("It's a abastract class."),
    routes = function(...) private$routes,
    servers = function(...) private$servers
  )
)

ViewFactory = R6Class(
  classname = "ViewFactory", 
  public = list(
    createContent = function(title = "Default Name", ...){
      tagItems <- list(...)
      lapply(tagItems, tagAssert)
      tags$div(style = "margin-top : -20px", tags$h1(title), tagItems)
    }
  )
)

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