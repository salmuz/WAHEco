mat_base <- define_transition(
  state_names = c("life", "death"),
  C,   p_death_reference,
  0,   1
)

mat_new <- define_transition(
  state_names = c("life", "death"),
  C,   p_death_new,
  0,   1
)

state_life <- define_state(
  cost_total = 0,
  qaly = discount(1, r_discount, period = 12)
)

state_death <- define_state(
  cost_total = 0,
  qaly = 0
)

strat_base <- define_strategy(
  transition = mat_base,
  life = state_life,
  death = state_death,
  starting_values = define_starting_values(
    cost_total = cost_strat_new
  )	
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

mortality_rate$probability <- (1 - exp(-mortality_rate$mortality_rate))

par_mod <- modify(
  par_mod,
  p_death_reference = look_up(
    data = mortality_rate,
    age = trunc(age_cycle), 
    value = "probability"
  )
)

par_mod <- modify(
  par_mod,
  risk_relative = 0.85,
  p_death_new = p_death_reference * risk_relative
)

par_mod <- modify(
  par_mod,
  cost_strat_new = 1, 
  r_discount = .04
)

fitting <- run_model(
  parameters = par_mod,

  base = strat_base,
  new = strat_new,

  cycles = 10,
  cost = cost_total,
  effect = qaly,

  method = "life-table",
  init = c(
    life = 1000,
    death = 0
  )
)
