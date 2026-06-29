#' Table 1 — structural parameter estimates
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A data frame of parameter estimates with confidence intervals.
#' @export
make_table_1 <- function(data = wave4_conjoint) {
  df_4 <- dplyr::mutate(data, x = .data$cash_billions)

  # Vectorized likelihood (matches analysis.Rmd: with(df_4, lik_x(x, ...))).
  # Do not use mapply() here — passing full covariate vectors in MoreArgs
  # creates an n×n matrix and the wrong objective.
  LL <- function(a = 1, b = 1, c = 1, g = 1, k = 1, sigma = 1) {
    lik <- structural_lik_x(
      df_4$x,
      sigma,
      a,
      b,
      c,
      g,
      k,
      df_4$trading_importance,
      df_4$risk,
      df_4$others_giving,
      df_4$others_average
    )
    -sum(log(lik))
  }

  fit <- bbmle::mle2(
    LL,
    optimizer = "nlminb",
    start = list(a = 240, b = -11, c = 41, g = 0.8, k = 4, sigma = 16),
    lower = list(a = 0, b = -20, c = -60, g = 0.01, k = -10, sigma = 0.02),
    upper = list(a = 400, b = 20, c = 60, g = 5, k = 10, sigma = 30)
  )

  out <- as.data.frame(bbmle::coef(bbmle::summary(fit)))
  names(out) <- c("estimate", "std.error", "statistic", "p.value")

  out |>
    dplyr::mutate(parameter = c("\u03b1", "\u03b2", "\u03b4", "\u03b3", "\u03ba", "\u03c3")) |>
    dplyr::relocate(.data$parameter) |>
    dplyr::mutate(
      conf.low = .data$estimate - 1.96 * .data$std.error,
      conf.high = .data$estimate + 1.96 * .data$std.error
    ) |>
    dplyr::mutate(dplyr::across(where(is.numeric), ~ round(.x, 2)))
}

#' @rdname make_table_1
#' @export
make_tab_1 <- make_table_1
