DSAComponent <- R6Class(
  classname = "DSAComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Determninistic sensitivity analysis", 
                          path = "/plot-dsa", nsid = "dsa-model"){
      super$initialize(title, path, nsid)
    },
    
    #' View interface of Deterministic sensivity analysis 
    #' @param plt.cost plotting the tornade uncertainty parameters analysis
    #' @param by_strategy the list strategies of fitting model 
    view = function(){
      tagList(
        fluidRow(
          box( #title = "Des filtres",
            status = "primary", solidHeader = TRUE,
            collapsible = FALSE, width = 12,
            column(width = 8,
              uiOutput(self$genNS("rbStrategy"))),
            column(width = 4,
              style = "text-align: center;margin-top: 18px;",
              actionButton(self$genNS("btnPlot"), "Apply"))
          )
        ),
        fluidRow(
          box(title = "Tornado uncertainty parameters analysis", status = "primary", 
              solidHeader = TRUE,
              width=12, plotOutput(self$genNS("plt.cost")), collapsible = T)
        )
      )
    },
    
    #' Server resquest Deterministic sensitivity analysis
    #' @method rbStrategy  
    #' @method plt.cost  
    server = function () {
      function(input, output, session, ...) {
        
        output$rbStrategy <- renderUI({
          ns <- session$ns
          choices <- list("All"="all")
          names <- as.list(heemod::get_strategy_names(fit.me))
          radioButtons(inputId = ns("by_strategy"), label = "Des Strategies", 
                       choices = c(choices, names), inline=TRUE)
        })
        
        options <- eventReactive(input$btnPlot, {
          parameters <- list()
          parameters[["strategy"]] <- switch(input$by_strategy != "all", input$by_strategy, NULL)
          parameters
        })
        
        output$plt.cost <- renderPlot({
          params <- options()
          default <- list(x = res_dsa, result = "cost")
          if(!is.null(params)) res <- do.call("plot", append(default, params))
          else res <- do.call("plot", default)
          print(res)
        })
        
      }
    },
    
    item = function(){
      menuSubItem(text = "DSA", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("cubes"))
    }
  )
)