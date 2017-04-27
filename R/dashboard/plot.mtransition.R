GraphComponent <- R6Class(
  classname = "GraphComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Matrice de transitions", path = "/other", nsid = "graph-trans"){
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
          print(plot(mat_chvp))
        })
        output$plot3 <- renderPlot({
          print(plot(mat_rchvp))
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