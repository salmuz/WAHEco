
# Decode variables models 

matrix_strategy_list <- list(mat_base, mat_new)
parameters <- par_mod
states_list <- list(state_life, state_death)
strategy_list <- list(strat_base, strat_new)
fit.me <- ec_mod

save(matrix_strategy_list, parameters, states_list, 
     strategy_list, fit.me, file = "R/2state_mod.RData")

# Decode other models 
res_mod <- fit.mod_ec
matrix_strategy_list <- lapply(res_mod$uneval_strategy_list, function(x) x$transition)
parameters <- res_mod$parameters
states_list <- lapply(res_mod$uneval_strategy_list$base$states, function(x) x)
strategy_list <- lapply(res_mod$uneval_strategy_list, function(x) x)
fit.me <- fit.mod_ec
save(matrix_strategy_list, parameters, states_list, 
     strategy_list, fit.me, res_dsa, res_psa, file = "R/heemodDemo.RData") 

