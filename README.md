# Web Application for Medico-Economics Decision Making (WeMEco)

You can use this library to model study case in medico-economics decision making or you can use the internal architecture web application for another customized web application. 

### Description 

This package has a general custom architecture web application using **shiny, shinydashboard, shiny.route and heemod** libraries, it has some web modules for medico-economics decision making and anyone can create news customized modules or component for later they are added to the web application container **AppRoot**.

### Dependencies
It's neccesary to install the following libraries:

  * **shinydashboard** 
    * Web site: https://github.com/rstudio/shinydashboard
    * Command: ``` install.packages("shinydashboard") ```
  * **devtools**
    * Command: ``` install.packages("devtools") ```
  * **shiny.router** 
    * Web site: https://github.com/Appsilon/shiny.router
    * Command: ``` devtools::install_github("Appsilon/shiny.router") ```
  * **heemod** 
    * Web site: https://github.com/pierucci/heemod
    * Version used for this version 
      * ``` devtools::install_github("salmuz/heemod@capionis_features") ```
  * **WeMEco**
    * Command: ``` devtools::install_github("salmuz/WeMEco") ```

### Demo

In order to execute a version demo of web application, we are execute the following commands in an environment R:

```R
library(shiny)
runGitHub(repo = "WeMEco", username = "salmuz", subdir = "inst/shinyapp/capionis")
```

### Features

  * Web Application container for modules 
  * Module container for web components:
    * Server method for catching the request http 
    * View method for showing a interface in html 
  
  
