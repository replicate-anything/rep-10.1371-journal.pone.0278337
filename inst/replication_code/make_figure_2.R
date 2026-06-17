#' Figure 2 — marginal effects of conditions
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_2 <- function(data = wave4_conjoint) {
  plot_marginal_effects(fit_marginal_effects(data))
}

#' @rdname make_figure_2
#' @export
make_fig_2 <- make_figure_2
