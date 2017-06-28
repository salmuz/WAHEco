library(WAHEco)
appRoot <- AppRoot$new(title = "App. Testing")

shinyApp(
  ui = appRoot$ui(),
  server = appRoot$server()
)

