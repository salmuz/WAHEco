DatabaseMeComponent <- R6Class(
  classname = "DatabaseMeComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Configuration database data", 
                          path = "/set-db-me", nsid = "set-db"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      tagList(
      )
    },
    server = function(){
      function(input, output, session, ...) {
      }
    },
    item = function(){
      menuSubItem(text = "Data tables", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("codepen"))
    }
  )
)
