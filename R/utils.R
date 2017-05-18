
#' 
#' Method for checking the inheritance of a component tag
#' @param tag variable
tagAssert <- function(tag) {
  if (!inherits(tag, c("shiny.tag","shiny.tag.list"))) {
    print(tag)
    stop("Expected an object with class 'shiny.tag'.")
  }
}


#'
#' Read a script R and save in a variable 
#' 
#' @param fpath path file to read
#' @export
#' 
read.scriptR <- function(fpath){
  
  if(!file.exists(fpath))
    stop(sprintf('The file %s to loading doesn\'t exist.', fpath))
  
  rfile <- file(fpath, "r")
  sbuffer <- NULL
  while(TRUE) {
    line = readLines(rfile, n = 1)
    if (length(line) == 0) break
    sbuffer <- paste(sbuffer, line, sep = '\n')
  }
  close(rfile)
  return(sbuffer)
}
