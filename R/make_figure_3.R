#' Figure 3 — effect of video treatment on individual solidarity
#'
#' @param data Wave 2 survey data. Defaults to [wave2_survey].
#' @return A ggplot object.
#' @export
make_figure_3 <- function(data = wave2_survey) {
  outcomes <- c("solidarity_behaviour", "solidarity_attitude")
  outcome_labels <- c("Solidarity Behavior", "Solidarity Attitude")

  models_basic <- stats::setNames(
    lapply(outcomes, function(y) {
      estimatr::lm_robust(
        stats::as.formula(paste(y, "~ treatment_video")),
        data = data
      )
    }),
    outcomes
  )

  dplyr::bind_rows(lapply(models_basic, broom::tidy), .id = "outcome") |>
    dplyr::filter(.data$term != "(Intercept)") |>
    dplyr::mutate(outcome = factor(.data$outcome, outcomes, outcome_labels)) |>
    ggplot2::ggplot(ggplot2::aes(.data$estimate, .data$outcome)) +
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
    ggplot2::theme_bw() +
    ggplot2::ggtitle("Effect of video treatment") +
    ggplot2::ylab("")
}

#' @rdname make_figure_3
#' @export
make_fig_3 <- make_figure_3
