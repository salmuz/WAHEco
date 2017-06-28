ModelMeComponent <- R6Class(
  classname = "ModelMeComponent",
  inherit = AppComponent,
  private = list(
    src.model = "",
    src.dsa = "",
    src.psa = ""
  ),
  public = list(
    initialize = function(title = "Setting a multistate model Medical-Economic", 
                          path = "/set-model-me", nsid = "set-modelme"){
      super$initialize(title, path, nsid)
      private$src.model <- WAHEco::read.scriptR("setting/default-model.R")
      private$src.dsa <- WAHEco::read.scriptR("setting/default-dsa.R")
      private$src.psa <- WAHEco::read.scriptR("setting/default-psa.R")
    },
    view = function(){
      tagList(
         tabsetPanel(
           id = self$genNS("setModelisation"),
           tabPanel("MulitState Model",
                value = "ChangeDataset",
                uiOutput(self$genNS("model.code")),
                actionButton(self$genNS("btnModel"), "Create/Update model"),
                h2(textOutput(self$genNS("outputModel")))
           ),
           tabPanel("Deterministe Sensibility Analyse",
                uiOutput(self$genNS("dsa.code")),
                actionButton(self$genNS("btnDSA"), "Execute DSA"),
                h2(textOutput(self$genNS("outputDSA")))
           ),
           tabPanel("Probability Sensibility Analyse",
                uiOutput(self$genNS("psa.code")),
                actionButton(self$genNS("btnPSA"), "Execute PSA"),
                h2(textOutput(self$genNS("outputPSA")))
           )
         )
      )
    },
    server = function(){
      
      function(input, output, session, ...) {
        
        ### Execution Molde ME
        
        output$model.code <- renderUI({
          ns <- session$ns
          aceEditor( outputId = ns("edit.model")
                    , value = private$src.model
                    , mode = "r"
                    , theme = "chrome"
                    , height = "500px"
                    , readOnly = FALSE
          )
        })
        
        rModel <- eventReactive(input$btnModel, {
          parse(text = input$edit.model)
        })
        
        output$outputModel <- renderText({
          rCode <- rModel()
          isolate(eval(rCode, envir = .GlobalEnv))
          decode_heemod(fitting)
          "Executed !!!"
        })
        
        ### Execution DSA
        
        rDsa <- eventReactive(input$btnDSA, {
          parse(text = input$edit.dsa)
        })
        
        output$outputDSA <- renderText({
          rCode <- rDsa()
          isolate(eval(rCode, envir = .GlobalEnv))
          "Executed !!!"
        })
        
        output$dsa.code <- renderUI({
          ns <- session$ns
          aceEditor( outputId = ns("edit.dsa")
                    , value = private$src.dsa
                    , mode = "r"
                    , theme = "chrome"
                    , height = "500px"
                    , readOnly = FALSE
          )
        })
        
        ### Execution PSA
        
        rPsa <- eventReactive(input$btnPSA, {
          parse(text = input$edit.psa)
        })
        
        output$outputPSA <- renderText({
          rCode <- rPsa()
          isolate(eval(rCode, envir = .GlobalEnv))
          "Executed !!!"
        })
        
        output$psa.code <- renderUI({
          ns <- session$ns
          aceEditor( outputId = ns("edit.psa")
                    , value = private$src.psa
                    , mode = "r"
                    , theme = "chrome"
                    , height = "500px"
                    , readOnly = FALSE
          )
        })
      }
    },
    item = function(){
      menuSubItem(text = "Modelisation", 
                  href= private$ROUTE_PATH, newtab = FALSE,
                  icon = shiny::icon("codepen"))
    }
  )
)

