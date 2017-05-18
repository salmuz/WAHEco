EvolutionCohortComponent <- R6Class(
  classname = "EvolutionCohortComponent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Evolution des cohortes dans le temps", 
                          path = "/plot-evolution", nsid = "evo-corhot"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      tagList(
        fluidRow(
          box( #title = "Des filtres",
            status = "primary", solidHeader = TRUE,
            collapsible = FALSE, width = 12,
            column(4,
                   radioButtons(inputId=self$genNS("byType"), label = "Des filtres",
                                choices = list("By strategy" = "by_strategy", 
                                               "By state" = "by_state"), 
                                selected = 1, inline=TRUE)
            ), 
            column(4,
              conditionalPanel(
                 condition = sprintf("input['%s'] == 'by_strategy'", self$genNS("byType")),
                 selectInput(inputId = self$genNS("by_strategy"), label = "Strategies",
                             choices = c("All" = "all"))
              ),
              conditionalPanel(
                condition = sprintf("input['%s'] == 'by_state'", self$genNS("byType")),
                selectInput(inputId = self$genNS("by_state"), label = "States",
                            choices = c("All" = "all"))
              )
            ),
            column(4,
                style = "text-align: center;margin-top: 20px;",
                actionButton(self$genNS("btnPlot"), "Apply")
            )
          )
        ),
        fluidRow(
          box(title = NULL, solidHeader = TRUE, width = 12,
              plotOutput(self$genNS("plt.evolution")))
        )
      )
    },
    server = function(){#  at evaluate 
      function(input, output, session, ...) {
        
        observe({
          selected <- input$byType
          choices <- list("all"="all")
          if(!is.null(selected)){
            if (selected == "by_strategy") names = as.list(heemod::get_strategy_names(fitting))
            else names = as.list(heemod::get_state_names(fitting))
            updateSelectInput(session, selected, choices = c(choices, names))
          }
        })
        
        options <- eventReactive(input$btnPlot, {
          parameters <- list(panels = input$byType)
          if(input$byType == "by_state"){
            parameters[["states"]] = switch(input$by_state != "all", input$by_state, NULL)
          }else{
            parameters[["strategy"]] = switch(input$by_strategy != "all", input$by_strategy, NULL)
          }
          parameters
        })
        
        output$plt.evolution <- renderPlot({
          params <- options()
          default <- list(x = fitting, type = "count")
          if(!is.null(params)){
            res <- do.call("plot", append(default, params))
            print(res)
          }
        })
      }
    },
    item = function(){
      menuSubItem(text = "Evolution de la cohorte", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("codepen"))
    }
  )
)

