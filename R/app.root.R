# source("R/pages.root.R",  chdir = TRUE)

# RouterRoot <- R6Class("RouterRoot",
#     private = list(
#       route = NULL,
#       namespaceId = NULL
#     ),
#     public = list(
#       initialize = function(route, namespaceId){
#         self$set(route, namespaceId)
#       },
#       set = function(route, namespaceId) { 
#         private$route <- route
#         private$namespaceId <- namespaceId
#         invisible(self)
#       },
#       get = function() { 
#         list(route = private$route, nsi = private$namespaceId)
#       }
#     )
# )


AppRoot <- R6Class("AppRoot", 
    public = list(
      initialize = function(title = "Default App"){
        private$title = title
      },
      ui = function(){
        dashboardPage(
          dashboardHeader(title = private$title),
          dashboardSidebar(
            sidebarMenu(private$sidebars)
            # sidebarMenu(menuItem("Dashboard", icon = shiny::icon("dashboard")))
          ),
          dashboardBody(router_ui())
        )
      },
      server = function(){
        
        routerRoot <- make_router(
            private$routes
        )
        
        function(input, output, session) {
          routerRoot(input, output)
          do.call("callModule", list(graph$server(), graph$namespaceID()))
          # callModule(, graph$namespace())
          # callModule(survival.server, survival.NAMESPACE_ID)
        }
      },
      addRoute = function(route, nameSpaceId){
        # private$routes <- c(private$routes, RouterRoot$new(route, nameSpaceId))
        invisible(self)
      },
      addModule = function (module = AppModule$new()){
        private$sidebars[[length(private$sidebars) + 1]] <- module$sidebar()
        private$routes <- c(private$routes, module$routes())
        
      },
      getSilder = function() private$sidebars
    ),
    private = list(
      title = NULL,
      routes = list(),
      sidebars = list()
    )
)

AppModule <- R6Class(
  classname = "AppModule",
  public = list(
    sidebar = function(...) stop("It's a abastract class."),
    routes = function(...) private$routes
  )
)

ViewFactory = R6Class(
  classname = "ViewFactory", 
  public = list(
    createContent = function(title = "Default Name", ...){
        tagItems <- list(...)
        lapply(tagItems, tagAssert)
        tags$div(style = "margin-top : -20px", tags$h1(title), tagItems)
    }
  )
)

DashboardModule = R6Class(
  classname = "Dashboard", 
  inherit = AppModule,
  public = list(
    initialize = function(){
      private$routes[["/"]] <- private$viewFactory$createContent(title = "Matrice de salmuz")
    },
    sidebar = function(){
      menuItem("Dashboard", icon = shiny::icon("dashboard"), private$items)
    },
    addComponent = function(component = AppComponent$new()){
      private$items[[component$route()]] <- component$item()
      private$routes[[component$route()]] <- 
        private$viewFactory$createContent(title = component$title(), component$view())
    }
  ),
  private = list(
    items = list(),
    routes = list(),
    viewFactory = ViewFactory$new()
  )
)


AppComponent <- R6Class(
  classname = "AppComponent", 
  public = list(
    initialize = function(title = 'Component Default'){
      if(is.null(private$TITLE)) private$TITLE <- title
    },
    view = function(...) stop("It's a abastract class."),
    server = function(...) stop("It's a abastract class."),
    route = function() private$ROUTE_PATH,
    namespaceID = function() private$NAMESPACE_ID,
    title = function() private$TITLE,
    fnc.namespace = function() NS(private$TITLE)
  ) 
)


GraphComponent <- R6Class(
  classname = "GraphComponent",
  inherit = AppComponent,
  public = list(
    view = function(){
      gns <- NS(private$NAMESPACE_ID) # it must be hidden 
      tagList(
        fluidRow(
          box(title = "Default traitement", status = "primary", solidHeader = TRUE,
              plotOutput(gns("plot2"))),
          box(title = "Nouveau traitement", status = "primary", solidHeader = TRUE,
              plotOutput(gns("plot3")))
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
  ),
  private = list(
    ROUTE_PATH = "/other",
    NAMESPACE_ID = "graph-trans",
    TITLE = "Matrice de transitions"
  )
)

# add each module or sub-module at main application
graph <- GraphComponent$new()
dashboard <- DashboardModule$new()
dashboard$addComponent(graph)

appRoot <- AppRoot$new("Capionis Demo")
appRoot$addModule(dashboard)



