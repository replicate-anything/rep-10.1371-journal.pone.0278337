#' Figure 8 — results refreshment sample
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_8 <- function(data = wave4_conjoint) {
  plot_marginal_effects(
    fit_marginal_effects_by(data, "group"),
    group_var = "group",
    flip_axes = TRUE,
    group_labels = c(Sample = c("refreshment", "main"))
  )
}

#' @rdname make_figure_8
#' @export
make_fig_8 <- make_figure_8
