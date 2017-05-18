PSAComponent <- R6Class(
  classname = "PSAComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Probabilistic sensitivity analysis", 
                          path = "/plot-psa", nsid = "psa-model"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      tagList(
        fluidRow(
          box(title = "Incremetal cost-effectiveness", status = "primary", 
              solidHeader = TRUE,
              width = 12, plotOutput(self$genNS("plt.ce")), collapsible=T)
        ),
        fluidRow(
          column( width = 6,
            box(title = "Cost-effectiveness acceptatibiliy curve", status = "primary", 
                solidHeader = TRUE, plotOutput(self$genNS("plt.ac")), 
                width = 12, collapsible=T)
          ),
          column( width = 6, 
            box(title = "Expected v alue of perfect information", status = "primary",
                solidHeader = TRUE, plotOutput(self$genNS("plt.evpi")), 
                width = 12, collapsible=T)
          )
        ),
        fluidRow(
          box(title = "Covariance analysis", status = "primary", 
              solidHeader = TRUE,
              width = 12, plotOutput(self$genNS("plt.cov")), collapsible=T)
        )
      )
    },
    server = function () {
      function(input, output, session, ...) {
        output$plt.ce <- renderPlot({
          plot(fitting.psa, type="ce")
        })
        output$plt.ac <- renderPlot({
          plot(fitting.psa, type="ac")
        })
        output$plt.evpi <- renderPlot({
          plot(fitting.psa, type="evpi")
        })
        output$plt.cov <- renderPlot({
          plot(fitting.psa, type="cov")
        })
      }
    },
    item = function(){
      menuSubItem(text = "PSA", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("bar-chart"))
    }
  )
)