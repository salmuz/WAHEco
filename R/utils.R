tagAssert <- function(tag) {
  if (!inherits(tag, c("shiny.tag","shiny.tag.list"))) {
    print(tag)
    stop("Expected an object with class 'shiny.tag'.")
  }
}
