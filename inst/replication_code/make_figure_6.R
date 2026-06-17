#' Figure 6 — marginal effects of conditions by party
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_6 <- function(data = wave4_conjoint) {
  plot_marginal_effects(
    fit_marginal_effects_by(data, "party"),
    group_var = "party",
    flip_axes = TRUE
  )
}

#' @rdname make_figure_6
#' @export
make_fig_6 <- make_figure_6
