#' Shared constants and helpers for the vaccine solidarity replication package
#'
#' @name helpers
#' @keywords internal
NULL

#' Deal labels for wave 4 vignettes
#' @export
deal_labels <- c(
  "No deal" = 0,
  "20 give 20 bn" = 1,
  "40 give 20b" = 2,
  "20 give 40 bn" = 3,
  "40 give 40 bn" = 4
)

#' Vignette lookup table for wave 4 conjoint
#' @return A tibble with 20 vignette rows.
#' @export
vignette_values <- function() {
  out <- expand.grid(
    trading_importance = 0:1,
    risk = 0:1,
    deal = 0:4
  )
  out <- out[order(out$trading_importance, out$risk), ]
  out$vignr <- seq_len(nrow(out))
  rownames(out) <- NULL
  out
}

#' Cash and vaccine amount grids for cumulative support curves
#' @export
amount_grids <- function() {
  list(
    cash = seq(0, 22, 0.5),
    vaccines = seq(0, 200, 1)
  )
}

#' Main-effect terms for marginal-effects regressions
#' @export
treatment_terms <- function() {
  list(
    norm = c(
      "trading_importance",
      "risk",
      "others_number_norm",
      "others_giving_norm"
    ),
    labels = c(
      "Trading importance",
      "Risk",
      "Number of others giving (10s)",
      "Amount given by other countries\n(10s of billions)"
    )
  )
}

#' Cumulative support curve
#'
#' @param x Numeric vector of contributions.
#' @param amounts Numeric grid of thresholds.
#' @return Data frame with columns `amounts` and `support`.
#' @export
support_curve <- function(x, amounts) {
  data.frame(
    amounts = amounts,
    support = vapply(
      amounts,
      function(j) mean(x >= j, na.rm = TRUE),
      numeric(1)
    ),
    stringsAsFactors = FALSE
  )
}

#' Closed-form optimum for the structural contribution model
#' @keywords internal
structural_maxx <- function(a, b, c, g, k, ZT, ZR, ZY, Zy) {
  AA <- -2 * (1 + g)
  BB <- -2 * ((1 + g) * ZY - g * k * Zy)
  CC <- 2 * g * k * Zy * ZY + a + b * ZT + c * ZR
  (-BB - sqrt(BB^2 - 4 * AA * CC)) / (2 * AA)
}

#' Normal likelihood at the structural optimum
#' @keywords internal
structural_lik_x <- function(x, sigma, a, b, c, g, k, ZT, ZR, ZY, Zy) {
  stats::dnorm(
    x,
    structural_maxx(a, b, c, g, k, ZT, ZR, ZY, Zy),
    sd = sigma
  )
}

#' Fit pooled marginal-effects models for cash and vaccine outcomes
#'
#' @param data Wave 4 conjoint data.
#' @return Tibble of tidy regression coefficients.
#' @export
fit_marginal_effects <- function(data) {
  formula_rhs <- "trading_importance * risk * others_number_norm * others_giving_norm + round"
  dplyr::bind_rows(
    cash_billions = broom::tidy(
      estimatr::lm_robust(
        stats::as.formula(paste("cash_billions ~", formula_rhs)),
        fixed_effects = ~id,
        se_type = "stata",
        data = data
      )
    ),
    doses = broom::tidy(
      estimatr::lm_robust(
        stats::as.formula(paste("doses ~", formula_rhs)),
        fixed_effects = ~id,
        se_type = "stata",
        data = data
      )
    ),
    .id = "outcome"
  )
}

#' Fit marginal-effects models split by a grouping variable
#'
#' @param data Wave 4 conjoint data.
#' @param split_var Character column name to split on.
#' @return Tibble with an extra grouping column.
#' @export
fit_marginal_effects_by <- function(data, split_var) {
  lvls <- unique(data[[split_var]])
  dplyr::bind_rows(lapply(lvls, function(level) {
    subset <- data[data[[split_var]] == level, , drop = FALSE]
    fit_marginal_effects(subset) |>
      dplyr::mutate(!!split_var := level)
  }))
}

#' Dot-and-whisker plot for marginal effects
#'
#' @param results Output of [fit_marginal_effects()] or [fit_marginal_effects_by()].
#' @param group_var Grouping column for dodged plots (`NULL` for a single series).
#' @param flip_axes Use horizontal treatment labels.
#' @return A ggplot object.
#' @export
plot_marginal_effects <- function(
  results,
  group_var = NULL,
  flip_axes = FALSE
) {
  terms <- treatment_terms()
  plot_df <- results |>
    dplyr::filter(.data$term %in% terms$norm) |>
    dplyr::mutate(
      Treatment = factor(.data$term, terms$norm, terms$labels),
      outcome = factor(
        .data$outcome,
        c("cash_billions", "doses"),
        c("Cash (billion Euros)", "Doses (Millions)")
      )
    )

  if (is.null(group_var)) {
    p <- ggplot2::ggplot(
      plot_df,
      ggplot2::aes(.data$estimate, .data$Treatment)
    ) +
      ggplot2::geom_point() +
      ggplot2::geom_errorbar(
        ggplot2::aes(xmin = .data$conf.low, xmax = .data$conf.high),
        width = 0.1
      ) +
      ggplot2::geom_vline(
        xintercept = 0,
        linetype = "longdash",
        lwd = 0.35,
        colour = "#B55555"
      ) +
      ggplot2::facet_grid(~outcome, scales = "free_x") +
      ggplot2::ylab("")
  } else {
    p <- ggplot2::ggplot(
      plot_df,
      ggplot2::aes(
        .data$Treatment,
        .data$estimate,
        color = .data[[group_var]],
        group = .data[[group_var]]
      )
    ) +
      ggplot2::geom_point(position = ggplot2::position_dodge(0.3)) +
      ggplot2::geom_errorbar(
        ggplot2::aes(ymin = .data$conf.low, ymax = .data$conf.high),
        position = ggplot2::position_dodge(0.3),
        width = 0.1
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "longdash",
        lwd = 0.35,
        colour = "#B55555"
      ) +
      ggplot2::facet_grid(~outcome, scales = "free_x") +
      ggplot2::xlab("")
  }

  p <- p + ggplot2::theme_bw()
  if (flip_axes) {
    p <- p + ggplot2::coord_flip()
  }
  p
}
