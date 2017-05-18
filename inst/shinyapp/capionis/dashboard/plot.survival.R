survival.ROUTER <- "/survival"
survival.NAMESPACE_ID <- "survival-trans"

survival.view <- function(ns){
  tagList(
    fluidRow(
      box(title = "Courbe de survie", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot2"))),
      box(title = "Évolution de la population", status = "primary", solidHeader = TRUE,
          plotOutput(ns("plot1")))
    )
  )
}

survival.itemMenu <- menuSubItem("Courbes Survie", 
                                 href=survival.ROUTER, newtab = FALSE,
                                 icon = shiny::icon("line-chart"))

survival.server <- function(input, output, session, ...) {
  output$plot1 <- renderPlot({
    print(plot(eco_mod, type = "counts", panel="by_state"))
  })
  
  output$plot2 <- renderPlot({
    interval_cycles <- eco_mod$eval_strategy_list$chvp$values$markov_cycle
    plotting <- plot(interval_cycles, eco_mod$eval_strategy_list$chvp$parameters$p_fct_param_chvp,
         type='l', col='blue', xlab="Time (cycles)", ylab="Probabilité état")
    lines(interval_cycles, eco_mod$eval_strategy_list$rchvp$parameters$p_fct_param_rchvp, col="red")
    lines(interval_cycles, eco_mod$eval_strategy_list$chvp$parameters$p_fct_parm_exp_chvp,
          lty=3, lwd=3, col="green")
    lines(interval_cycles, eco_mod$eval_strategy_list$rchvp$parameters$p_fct_parm_exp_rchvp,
          lty=3, lwd=3, col="violet")
  })
}
