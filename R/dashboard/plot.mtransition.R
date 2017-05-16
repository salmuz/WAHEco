GraphComponent <- R6Class(
  classname = "GraphComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Matrices de transitions", path = "/plot-graph", nsid = "graph-trans"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      tagList(
        fluidRow(
          box(title = "Default traitement", status = "primary", solidHeader = TRUE,
              plotOutput(self$genNS("default"))),
          box(title = "Nouveau traitement", status = "primary", solidHeader = TRUE,
              plotOutput(self$genNS("new")))
        )
      )
    },
    server = function () {
      function(input, output, session, ...) {
        output$default <- renderPlot({
          plot(matrix_strategy_list[[1]])
        })
        output$new <- renderPlot({
          plot(matrix_strategy_list[[2]])
        })
      }
    },
    item = function(){
      menuSubItem(text = "Matrices de transitions", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("codepen"))
    }
  )
)