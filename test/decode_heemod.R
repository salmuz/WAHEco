
# Decode variables models 

matrix_strategy_list <- list(mat_base, mat_new)
parameters <- par_mod
states_list <- list(state_life, state_death)
strategy_list <- list(strat_base, strat_new)
fit.me <- ec_mod

save(matrix_strategy_list, parameters, states_list, 
     strategy_list, fit.me, file = "R/2state_mod.RData")
