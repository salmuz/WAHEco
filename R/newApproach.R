rm(list = ls())
graph.router <- "/other"

graphTrans.view <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      box(title = "Default traitement", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot2"), width = 500, height = 500)),
      box(title = "Nouveau traitement", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot3"), width = "100%", height = 100))
    )
  )
}

graphTrans.view2 <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      box(title = "----->>>", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot3"), width = "100%", height = 100))
    )
  )
}




graphTrans.itemMenu <- menuSubItem(text = "Matrice de transitions", 
                                   href= graph.router, newtab = FALSE,
                                   icon = shiny::icon("codepen"))

graphTrans.server <- function(input, output, session, salmuzId, ...) {
  cat(file=stderr(), "drawing histogram with", ROUTER_UI_ID,  "\n")
  
  output$plot2 <- renderPlot({
    xlab <- input[[HIDDEN_ROUTE_INPUT]]
    print(plot(1:10, 21:30, xlab = xlab))
  })
}

root_page <- graphTrans.view2("salmuz")
other_page <- graphTrans.view("calors")

library(shinydashboard)
library(shiny)

router <- make_router(
  route("/index", root_page),
  route("/other", other_page)
)

ui <- dashboardPage(
  dashboardHeader(title = "Capionis Demo"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Matrice de transitions", 
               href= "/other", newtab = FALSE,
               icon = shiny::icon("codepen")),
      menuItem(text = "Matrice de transitions", 
               href= "/index", newtab = FALSE)
    )
  ),
  dashboardBody(
    router_ui()
  )
)

server <- function(input, output, session) {
  router(input, output)
  # callModule(graphTrans.server, "calors", session, "salmuz")
}


shinyApp(ui, server)


