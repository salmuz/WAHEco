pages <- function(title = "Default Name", ...){
  tagItems <- list(...)
  lapply(tagItems, tagAssert)
  tags$div(style = "margin-top : -20px",
           h1(title), tagItems)
}

source("dashboard.root.R", chdir = T)

router <- make_router(
  dashboard.routers
)

pl.root.slider <- sidebarMenu(
  dashboard.sidebar
)

pl.root.body <- router_ui()



