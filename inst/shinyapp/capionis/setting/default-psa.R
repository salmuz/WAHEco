def.parm.psa <- define_psa(
  age_base ~ normal(mean = 65, sd = 5),
  risk_relative ~ lognormal(mean = 0.85, sd = .1),
  cost_strat_new ~ gamma(mean = 1, sd = .2)
)

fitting.psa <- run_psa(model = fitting, psa = def.parm.psa, N = 1000)
