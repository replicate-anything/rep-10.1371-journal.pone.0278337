#' Figure 7 — marginal effects of conditions by migration background
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_7 <- function(data = wave4_conjoint) {
  plot_marginal_effects(
    fit_marginal_effects_by(data, "migration_background"),
    group_var = "migration_background",
    flip_axes = TRUE
  )
}

#' @rdname make_figure_7
#' @export
make_fig_7 <- make_figure_7
