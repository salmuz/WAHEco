rm(list = ls())

mat_base <- define_transition(
  state_names = c("life", "death"),
  C,   p_death_reference,
  0,   1
)
# avec le risque relative ?
mat_new <- define_transition(
  state_names = c("life", "death"),
  C,   p_death_new,
  0,   1
)


state_life <- define_state(
  cost_total = dispatch_strategy(
    base = 0,
    new = cost_strat_new / (1-p_death_new) # hit ??? so bad, il n'y a pas de coût constant
  ),
  qaly = discount(1, ratio_update, T)
)

state_death <- define_state(
  cost_total = 0,
  qaly = 0
)

strat_base <- define_strategy(
  transition = mat_base,
  life = state_life,
  death = state_death
)

strat_new <- define_strategy(
  transition = mat_new,
  life = state_life,
  death = state_death
)

par_mod <- define_parameters(
  age_base = 65,
  age_cycle = markov_cycle + age_base
)

taux_mortalite <- read.csv("../Validation/Capionis_Medico_Economic/taux_mortalite.csv", header = T, sep = ';',
                           colClasses = c("numeric", "numeric"))
taux_mortalite$prob_death <- (1 - exp(-taux_mortalite$Taux_mortalite_annuelle))

par_mod <- modify(
  par_mod,
  p_death_reference = look_up(
    data = taux_mortalite,
    age = age_cycle - 1, # Prob de mortalité pour l'individus du cycle passé.
    value = "prob_death"
  )
)

par_mod <- modify(
  par_mod,
  risk_relative = 0.85,
  p_death_new = p_death_reference * risk_relative
)

par_mod <- modify(
  par_mod,
  cost_strat_new = ifelse(model_time == 1, 1, 0), # hit for simulating cost constant 1 * 1000
  ratio_update = .04
)

fit.ec.mod <- run_model(
  parameters = par_mod,

  base = strat_base,
  new = strat_new,

  cycles = 10,
  cost = cost_total,
  effect = qaly,
  
  init_cost = c(
    life = 1000,
    death = 1000
  ),
  
  method = "beginning",
  init = c(
    life = 1000,
    death = 0
  )
)
