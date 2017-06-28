library(WAHEco)
appRoot <- AppRoot$new(title = "App. Testing")
simpleModule <- SimpleModule$new(title = "Première module")
SimpleComponent <- R6Class(
  classname = "SimpleComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Testing", path = "/testing", nsid = "test-nsid"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      fluidPage( titlePanel("Testing"))
    },
    server = function () {
      function(input, output, session, ...) {
      }
    },
    item = function(){
      menuSubItem(text = "DSA", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("cubes"))
    }
  )
)

simpleComponent <- SimpleComponent$new(title = "Composante vide")
simpleModule$addComponent(simpleComponent)
appRoot$addModule(simpleModule)

shinyApp(
  ui = appRoot$ui(),
  server = appRoot$server()
)
