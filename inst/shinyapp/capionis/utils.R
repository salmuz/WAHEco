decode_heemod <- function(fitting, fitting.psa){
  matrix_strategy_list <- lapply(fitting$uneval_strategy_list, function(x) x$transition)
  states_list <- lapply(fitting$uneval_strategy_list$base$states, function(x) x)
  strategy_list <- lapply(fitting$uneval_strategy_list, function(x) x)
  assign("matrix_strategy_list", matrix_strategy_list, envir = .GlobalEnv)
  assign("states_list", states_list, envir = .GlobalEnv)
  assign("strategy_list", strategy_list, envir = .GlobalEnv)
  assign("fitting", fitting, envir = .GlobalEnv)
  assign("fitting.psa", fitting.psa, envir = .GlobalEnv)
}
