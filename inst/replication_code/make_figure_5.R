#' Figure 5 — levels of support by migration background
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_5 <- function(data = wave4_conjoint) {
  grids <- amount_grids()
  sm <- lapply(0:1, function(m) {
    support_curve(
      data[data$migration_background == m, "cash_billions", drop = TRUE],
      grids$cash
    )
  })
  names(sm) <- c("Non migrant", "Migrant")
  sm <- dplyr::bind_rows(sm, .id = "Migration_background")

  ggplot2::ggplot(
    sm,
    ggplot2::aes(.data$amounts, .data$support, color = .data$Migration_background)
  ) +
    ggplot2::geom_line() +
    ggplot2::ylim(0, 1) +
    ggplot2::theme_bw() +
    ggplot2::xlab("German contribution (bn Euro)") +
    ggplot2::ylab("Share supporting") +
    ggplot2::theme(legend.position = "bottom")
}

#' @rdname make_figure_5
#' @export
make_fig_5 <- make_figure_5
