graph.ROUTER <- "/other"
graph.NAMESPACE_ID <- "graph-trans"

graphTrans.view <- function(ns){
  tagList(
    fluidRow(
      box(title = "Default traitement", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot2"))),
      box(title = "Nouveau traitement", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot3")))
    )
  )
}

graphTrans.itemMenu <- menuSubItem(text = "Matrices de transitions",
                    href= graph.ROUTER, newtab = FALSE,
                    icon = shiny::icon("codepen"))

graphTrans.server <- function(input, output, session, ...) {
  output$plot2 <- renderPlot({
    print(plot(mat_chvp))
  })
  output$plot3 <- renderPlot({
    print(plot(mat_rchvp))
  })
}
