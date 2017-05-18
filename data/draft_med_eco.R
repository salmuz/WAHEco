library(heemod)
patients_cohort <- 1000

mat_chvp <- define_transition(
  state_names = c("pfs", "prog", "mort"),
  p_fct_param_chvp,          C,        p_death_age,
  0           ,    0.9878,           0.0122,
  0           ,         0,                1
)

mat_rchvp <- define_transition(
  state_names = c("pfs", "prog", "mort"),
  p_fct_param_rchvp,          C,        p_death_age,
  0           ,    0.9878,           0.0122,
  0           ,         0,                1
)

fct_cost_chempotherapy <- function(cost_6_first_cycles, cost_before_12_cycles, cycle){
  return(ifelse(cycle < 7, cost_6_first_cycles,
                ifelse( cycle < 13, cost_before_12_cycles, 0)))
}

#  Notez que comme la longueur du cycle est d’un mois, pour les années de vie et les QALY,
# une conversion est nécessaire en divisant par 12.

state_pfs <- define_state(
  cost_chemotherapy = dispatch_strategy(
    chvp = fct_cost_chempotherapy(chvp_6_first_months, chvp_next_months, markov_cycle),
    rchvp = fct_cost_chempotherapy(rchvp_6_first_months, rchvp_next_months, markov_cycle)
  ),
  cost_administration = dispatch_strategy(
    chvp = ifelse(markov_cycle/12 <= 1, cost_admin_chimio, 0),
    # pareil si l'on met moins de 12 cycles = 1 année
    rchvp = ifelse(markov_cycle <= 12, cost_admin_rchimio, 0)
  ),
  cost_monitoring = cost_monitoring_pfs,
  cost_drugs_second = 0,

  # Compute gross cost and net cost (total)
  cost_bruts = (cost_chemotherapy + cost_administration + cost_monitoring +
                  cost_drugs_second)/patients_cohort,
  cost_total = discount(cost_bruts, discount_fr),

  # compute the QALY (bruts and net), calculé en année (divisé par 12)
  qaly_bruts = effect_qaly_pfs/patients_cohort,
  # discount_cout = discount_rate(discount, 1, trunc((markov_cycle-1)/12)),
  # discount_qaly = discount_rate(discount, 1, trunc((markov_cycle-1)/12)),
  qaly = discount(qaly_bruts, discount_fr)/12
)

state_prog <- define_state(
  cost_chemotherapy =  0,
  cost_administration = 0,
  cost_monitoring = cost_monitoring_prog,
  cost_drugs_second = 195,

  # Compute gross cost and net cost (total)
  cost_bruts = (cost_chemotherapy + cost_administration + cost_monitoring +
                  cost_drugs_second)/patients_cohort,
  cost_total = discount(cost_bruts, discount_fr),

  # compute the QALY (bruts and net), calculé en année (divisé par 12)
  qaly_bruts = effect_qaly_prog/patients_cohort,
  # qaly = qaly_bruts/(discount_qaly*12)
  qaly = discount(qaly_bruts, discount_fr)/12
)

state_mort <- define_state(
  cost_chemotherapy = 0,
  cost_administration = 0,
  cost_monitoring = 0,
  cost_drugs_second = 0,
  cost_bruts = 0,
  cost_total = 0,
  qaly_bruts = 0,
  qaly = 0
)

strat_chvp <- define_strategy(
  transition = mat_chvp,
  pfs = state_pfs,
  prog = state_prog,
  mort = state_mort
)

strat_rchvp <- define_strategy(
  transition = mat_rchvp,
  pfs = state_pfs,
  prog = state_prog,
  mort = state_mort
)

# Comme chaque cycle sera un mois donc on prendre 1/12 increment par cycle à l'agê
par_mod <- define_parameters(
  year_current= trunc(markov_cycle/12),
  age_base = 53,
  age_cycle = year_current + age_base
)

taux_mortalite <- read.csv("../Validation/Capionis_Medico_Economic/taux_mortalite_rituximab.csv", header = T, sep = ';',
                           colClasses = c("numeric", "numeric"))
taux_mortalite$prob_death <- (1 - exp(log(1-taux_mortalite$prob_death_year)/12))

# Survival conditionnelle :
## On s’intéresse donc à la survie d’un élément après un instant markov_cycle,
## sachant qu’il a déjà survecu jusqu’en (markov_cycle - 1)
## (i.e. tip utilisé aussi pour demontrer l'estimateur kaplan-meier)
#### Et pour quoi, on ne calcule pas juste la probabilité de survie à temp t ?
#### on parlerait de semi-markov ou markov non-homogeneous?
pr_survival_conditional <- function(scale, shape, cycle){
  exp(scale * (((cycle - 1)^shape) - (cycle^shape)))
}
## sinon, en cas contraire, (1-pr_survival_conditional) est la probabilité
## qu'événement d'intérêt tombe au cours d'un cycle [ markov_cycle-1; markov_cycley ]

par_mod <- modify(
  par_mod,
  p_death_age = look_up(
    data = taux_mortalite,
    age = trunc(age_cycle),
    value = "prob_death"
  ),
  scale = 0.00178,
  shape = 1.6304,
  p_fct_param_chvp = pr_survival_conditional(scale, shape, markov_cycle)
)

par_mod <- modify(
  par_mod,
  ratio_hazard = 0.514,
  period_therapy = 42,
  shape_rchvp = 1.6304,
  scale_rchvp = ratio_hazard*scale,
  p_trans_prob_rchvp = pr_survival_conditional(scale_rchvp, shape_rchvp, markov_cycle),
  p_fct_param_rchvp = ifelse(markov_cycle < period_therapy, p_trans_prob_rchvp, p_fct_param_chvp),

  p_fct_parm_exp_chvp = exp(-0.0185752081387471),
  p_fct_parm_exp_rchvp = ifelse(markov_cycle < period_therapy, exp(-0.0096), p_fct_parm_exp_chvp)
)

par_mod <- modify(
  par_mod,

  chvp_6_first_months = 619.51,
  chvp_next_months = 456.92,
  rchvp_6_first_months = 1735.14,
  rchvp_next_months = 294.32,

  cost_admin_chimio = 309,
  cost_admin_rchimio =	430,

  cost_monitoring_pfs = 34.33,
  cost_monitoring_prog = 103,

  discount_fr = rescale_discount_rate(0.035, 12, 1), # taux d'actualisation

  effect_qaly_pfs = .805,
  effect_qaly_prog =.618
)

eco_mod <- run_model(
  parameters = par_mod,

  chvp = strat_chvp,
  rchvp = strat_rchvp,

  cycles = 180,
  cost = cost_total,
  effect = qaly,

  #method = "life-table"
  method = "beginning",
  init = c(
    pfs = patients_cohort,
    prog = 0,
    mort = 0
  )
)




# table_icer <- matrix(c(eco_mod$run_model$qaly, 0, eco_mod$run_model$cost_total, 0), ncol=3, byrow=T)
# colnames(table_icer) <- c("CHVP", "R-CHVP", "Diff")
# rownames(table_icer) <- c("QALYs", "Coûts")
# table_icer[,3] <- c(table_icer[1,2] - table_icer[1,1], table_icer[2,2] - table_icer[2,1])
# 
# #Plots
# interval_cycles <- eco_mod$eval_strategy_list$chvp$values$markov_cycle
# plot(interval_cycles, eco_mod$eval_strategy_list$chvp$counts$pfs, type='l',
#      ylab = "Nombre de patients", xlab = "Mois",col="blue")
# lines(interval_cycles, eco_mod$eval_strategy_list$rchvp$counts$pfs, type='l', col="red")
# legend("topright", c("CHVP", "R-CHVP"), col=c("blue", "red"), lty=c(1,1))
# 
# 
# options(scipen=5)
# couts_by_strat <- t(as.matrix(eco_mod$run_model[1:4]))/patients_cohort
# colnames(couts_by_strat) <- c('CHVP', 'R-CHVP')
# barplot(couts_by_strat, col=c("steelblue", "red", "green", "lightsteelblue"), space=2)
# legend("center", fill=c("steelblue", "red", "green", "lightsteelblue"),
#        legend=rownames(couts_by_strat))
# 
# plot(interval_cycles, eco_mod$eval_strategy_list$chvp$parameters$p_fct_param_chvp,
#      type='l', col='blue', xlab="Time (cycles)", ylab="Probabilité état")
# lines(interval_cycles, eco_mod$eval_strategy_list$rchvp$parameters$p_fct_param_rchvp, col="red")
# lines(interval_cycles, eco_mod$eval_strategy_list$chvp$parameters$p_fct_parm_exp_chvp,
#       lty=3, lwd=3, col="green")
# lines(interval_cycles, eco_mod$eval_strategy_list$rchvp$parameters$p_fct_parm_exp_rchvp,
#       lty=3, lwd=3, col="violet")

