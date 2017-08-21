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

# Compute values for Cost-Effectiveness Acceptability Curve by using the net benefits framework
.compute.ceac.values <- function(x, wtp_thresholds = c(1000)){
  N <- x$N
  x <- .scale.psa(x)
  x %>%
    dplyr::mutate(.strategy_names = "PSA", .key = 1) %>%
    dplyr::left_join(
      tibble::tibble(
        .wtp = wtp_thresholds,
        .key = 1
      ),
      by = ".key"
    ) %>%
    dplyr::group_by_(~ .index) %>% 
    dplyr::mutate_(
      .nmb = ~ .effect * .wtp - .cost,
      .top_strategy = ~(.nmb > 0)
    ) %>%
    dplyr::group_by_(~ .wtp) %>% 
    dplyr::summarise_(.n = ~ sum(.top_strategy)) %>%
    dplyr::mutate_(.p = ~ .n / N)
}

# Normalize cost-effectivenness in relation to cohort simulation (population entering)
# and to calculate the difference in cost/effect between two possible interventions
.scale.psa <- function(x){
  .bs <- heemod:::get_central_strategy.psa(x)
  psa <- x$psa[, c('.cost', '.effect', '.strategy_names', '.index', '.n_indiv')]
  psa %>% 
    dplyr::mutate_(
      .cost = ~ .cost / .n_indiv,
      .effect = ~ .effect / .n_indiv
    ) %>%
    dplyr::group_by_(".index") %>% 
    dplyr::mutate_(
      .cost = ~ (.cost - sum(.cost * (.strategy_names == .bs))),
      .effect = ~ (.effect - sum(.effect * (.strategy_names == .bs)))
    ) %>% 
    dplyr::filter(.strategy_names != .bs) %>%
    dplyr::ungroup()
}


plot.psa.ce <- function(x, y, ic = .95){
  bmodel <- heemod:::get_model_results.psa(x)
  psa <- .scale.psa(x)
  psa[, 3] <- 'PSA'
  
  .fn_add_row <- function(psa, model, name="Mean"){
    .col.ce <-  c('.cost', '.effect')
    bmce <- dplyr::arrange_(model, ~ .effect)[,.col.ce]/model$.n_indiv[1]
    psa <- psa %>% rbind(c(diff(as.matrix(bmce)), rep(0, 3)))
    psa[nrow(psa), 3] <- name
    psa
  }
  
  psa <- .fn_add_row(psa, bmodel)
  psa <- .fn_add_row(psa, y$run_model, name="Deterministic")
  ic.label = paste("IC ", 100*ic, "%", sep = "")
  psa <- tibble::add_column(psa, .ic="ic")
  
  ggplot2::ggplot(data = psa,
                  ggplot2::aes_string( x = ".effect", y = ".cost", 
                                       colour = ".strategy_names", fill=".ic")) +
    ggplot2::geom_point() +
    ggplot2::scale_colour_hue(name = "Model") +
    ggplot2::xlab("Incremental effect") +
    ggplot2::ylab("Incremental cost") +
    ggplot2::stat_ellipse(
      ggplot2::aes_string(x = ".effect", y = ".cost"),  
      color='black', type = "norm", linetype = 2) +
    ggplot2::scale_fill_manual(name = "", values="black", label = ic.label) 
}

plot.psa.ac <- function(x, n = 100, max_wtp = 10000){
  
  wtp_thresholds <- heemod:::generate_wtp(max_wtp = max_wtp, 
                                          n = n, log_scale = FALSE)
  
  y <- .compute.ceac.values(x, wtp_thresholds)
  
  ggplot2::ggplot() +
    ggplot2::geom_line(y, alpha=0.9,
                       mapping = ggplot2::aes(x = .wtp, y = .p, color='steelblue')) +
    ggplot2::ylim(0, max(y$.p)) +
    ggplot2::xlab("Willingness to pay") +
    ggplot2::ylab("Probability of cost-effectiveness") 
}

plot.psa.conv <- function(x){
  psa <- .scale.psa(x)
  psa <- psa %>% dplyr::mutate_(.icer = ~ (.cost / .effect)) 
  ggplot2::ggplot(psa, ggplot2::aes(x=.index, y=cumsum(.icer)/.index)) +
    ggplot2::geom_line(color='steelblue', alpha=0.9) +
    ggplot2::xlab("Nb. simulations") +
    ggplot2::ylab(expression("Delta Cost / Delta Effect")) +
    ggplot2::theme(legend.position="none")
}
