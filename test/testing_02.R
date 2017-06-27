TestingIndependent <- R6Class(
  classname = "TestingIndependent",
  inherit = AppComponent,
  public = list(
    initialize = function(title = "Testing", 
                          path = "/testing", nsid = "test-nsid"){
      super$initialize(title, path, nsid)
    },
    view = function(){
      fluidPage(
        titlePanel("Testing"),
        sidebarLayout(
          sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
          ),
          mainPanel(
            plotOutput("distPlot")
          )
        )
      )
    },
    server = function () {
      function(input, output, session, ...) {
        output$distPlot <- renderPlot({
          x    <- faithful[, 2]  # Old Faithful Geyser data
          bins <- seq(min(x), max(x), length.out = input$bins + 1)
          
          # draw the histogram with the specified number of bins
          hist(x, breaks = bins, col = 'darkgray', border = 'white')
        })
        
      }
    }
  )
)
iid <- TestingIndependent$new()

shinyApp(
  ui = iid$view(),
  server = iid$server()
)
