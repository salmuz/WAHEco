source("graph.transitions.R", chdir = TRUE)
source("curve-survival.R", chdir = TRUE)

dashboard.sidebar <- sidebarMenu(
  menuItem("Dashboard", icon = icon("dashboard"),
           graphTrans.itemMenu,
           survival.itemMenu,
           menuSubItem("Coûts", 
                       tabName = "ptcost",
                       icon = shiny::icon("bar-chart"))
  ),
  menuItem("Administration", icon = icon("info"))
           
)

dashboard.routers <- list()
dashboard.routers[[graph.ROUTER]] = pages(title = "Matrice de transitions", graphTrans.view(NS(graph.NAMESPACE_ID)))
dashboard.routers[[survival.ROUTER]] = pages(title = "Analyse courbes survie", survival.view(NS(survival.NAMESPACE_ID)))
dashboard.routers[['/']] = pages(title = "Matrice de salmuz")
