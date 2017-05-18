source("setting/set.model-me.R")
source("setting/set.database-me.R")

#' Setting Module 
#' 
#' Adding the modules customized (manually for the user)
#' The user should add the customized modules
#' 
SettingModule = R6Class(
  classname = "SettingModule", 
  inherit = WeMeco::SimpleModule,
  public = list(
    initialize = function(){
      super$initialize("/setting", "Setting parameters", 
                       icon = "cogs", nameItem = "Setting")
    }
  )
)

modelme <- ModelMeComponent$new()
dbme <- DatabaseMeComponent$new()

setting <- SettingModule$new()
setting$addComponent(modelme)
setting$addComponent(dbme)