
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
          column( width = 6,
            box(title = "Incremetal cost-effectiveness", status = "primary", 
              solidHeader = TRUE,
              width = 12, plotOutput(self$genNS("plt.ce")), collapsible=T)),
           column( width = 6,
                  box(title = "Cost-effectiveness acceptatibiliy curve", status = "primary", 
                      solidHeader = TRUE, plotOutput(self$genNS("plt.ac")), 
                      width = 12, collapsible=T))
        ),
        fluidRow(
          column( width = 6,
                  box(title = "Convergence Simulation PSA", status = "primary", 
                      solidHeader = TRUE,
                      width = 12, plotOutput(self$genNS("plt.conv")), collapsible=T)),
          column( width = 6,
            box(title = "Expected v alue of perfect information", status = "primary",
                solidHeader = TRUE, plotOutput(self$genNS("plt.evpi")),
                width = 12, collapsible=T))
        )
        # fluidRow(
        #   box(title = "Covariance analysis", status = "primary", 
        #       solidHeader = TRUE,
        #       width = 12, plotOutput(self$genNS("plt.cov")), collapsible=T)
        # )
      )
    },
    server = function () {
      function(input, output, session, ...) {
        output$plt.ce <- renderPlot({
          plot(fitting.psa, type="ce")
        })
        output$plt.conv <- renderPlot({
          plot(fitting.psa, type="conv")
        })
        output$plt.ac <- renderPlot({
          plot.ac <- plot(fitting.psa, strategy = fitting.psa$model$root_strategy, type='ac') + 
            ggplot2::ylim(.5, 1) +
            ggplot2::theme(legend.title = ggplot2::element_blank(), 
                           legend.text = ggplot2::element_blank())
          plot(plot.ac, type="ac", max_wtp = 30000, log_scale = F)
        })
        output$plt.evpi <- renderPlot({
          plot(fitting.psa, type="evpi", max_wtp = 30000, log_scale = F)
        })
        # output$plt.cov <- renderPlot({
        #   plot(fitting.psa, type="cov")
        # })
      }
    },
    item = function(){
      menuSubItem(text = "PSA", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("bar-chart"))
    }
  )
)
