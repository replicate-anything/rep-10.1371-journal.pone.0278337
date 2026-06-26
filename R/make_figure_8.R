#' Figure 8 — results refreshment sample
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_8 <- function(data = wave4_conjoint) {
  results <- fit_marginal_effects_by(data, "group")
  results$group <- factor(
    results$group,
    levels = c(4, 5),
    labels = c("refreshment", "main")
  )
  plot_marginal_effects(
    results,
    group_var = "group",
    flip_axes = TRUE
  )
}

#' @rdname make_figure_8
#' @export
make_fig_8 <- make_figure_8
