def.parm.dsa <- define_dsa(
  age_base, 50, 75,
  risk_relative, 0.68, 1.02,
  cost_strat_new, .8, 1.2,
  r_discount, 0, 0.1
)

fitting.dsa <- run_dsa(model = fitting, dsa = def.parm.dsa)
