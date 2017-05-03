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
              plotOutput(self$genNS("plot2"))),
          box(title = "Nouveau traitement", status = "primary", solidHeader = TRUE,
              plotOutput(self$genNS("plot3")))
        )
      )
    },
    server = function () { #  at evaluate 
      function(input, output, session, ...) {
        output$plot2 <- renderPlot({
          print(plot(matrix_strategy_list[[1]]))
        })
        output$plot3 <- renderPlot({
          print(plot(matrix_strategy_list[[2]]))
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