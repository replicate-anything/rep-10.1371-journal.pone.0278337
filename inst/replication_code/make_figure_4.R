#' Figure 4 — levels of support by party
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A ggplot object.
#' @export
make_figure_4 <- function(data = wave4_conjoint) {
  grids <- amount_grids()
  sp <- lapply(unique(data$party), function(p) {
    support_curve(
      data[data$party == p, "cash_billions", drop = TRUE],
      grids$cash
    )
  })
  names(sp) <- unique(data$party)
  sp <- dplyr::bind_rows(sp, .id = "Party")

  ggplot2::ggplot(sp, ggplot2::aes(.data$amounts, .data$support, color = .data$Party)) +
    ggplot2::geom_line() +
    ggplot2::ylim(0, 1) +
    ggplot2::theme_bw() +
    ggplot2::xlab("German contribution (bn Euro)") +
    ggplot2::ylab("Share supporting") +
    ggplot2::theme(legend.position = "bottom")
}

#' @rdname make_figure_4
#' @export
make_fig_4 <- make_figure_4
