tagAssert <- function(tag) {
  if (!inherits(tag, c("shiny.tag","shiny.tag.list"))) {
    print(tag)
    stop("Expected an object with class 'shiny.tag'.")
  }
}

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



