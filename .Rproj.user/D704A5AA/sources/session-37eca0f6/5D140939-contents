#' Figure 1 — distribution of support for contributions of different sizes
#'
#' @param data Wave 4 conjoint data. Defaults to [wave4_conjoint].
#' @return A multi-panel ggplot object from `egg::ggarrange`.
#' @export
make_figure_1 <- function(data = wave4_conjoint) {
  grids <- amount_grids()

  s1 <- dplyr::bind_rows(
    Low = support_curve(
      data[data$risk_factor == "Low" & data$trading_factor == "Low", "cash_billions", drop = TRUE],
      grids$cash
    ),
    High = support_curve(
      data[data$risk_factor == "High" & data$trading_factor == "High", "cash_billions", drop = TRUE],
      grids$cash
    ),
    .id = "Costs"
  )

  s2 <- dplyr::bind_rows(
    Low = support_curve(
      data[data$deal == "No deal", "cash_billions", drop = TRUE],
      grids$cash
    ),
    High = support_curve(
      data[data$deal == "40 give 40 bn", "cash_billions", drop = TRUE],
      grids$cash
    ),
    .id = "Multilateralism"
  )

  s3 <- dplyr::bind_rows(
    Low = support_curve(
      data[data$risk_factor == "Low" & data$trading_factor == "Low", "doses", drop = TRUE],
      grids$vaccines
    ),
    High = support_curve(
      data[data$risk_factor == "Low" & data$trading_factor == "High", "doses", drop = TRUE],
      grids$vaccines
    ),
    .id = "Costs"
  )

  s4 <- dplyr::bind_rows(
    Low = support_curve(
      data[data$deal == "No deal", "doses", drop = TRUE],
      grids$vaccines
    ),
    High = support_curve(
      data[data$deal == "40 give 40 bn", "doses", drop = TRUE],
      grids$vaccines
    ),
    .id = "Multilateralism"
  )

  egg::ggarrange(
    ggplot2::ggplot(s1, ggplot2::aes(.data$amounts, .data$support, color = .data$Costs)) +
      ggplot2::geom_line() + ggplot2::ylim(0, 1) + ggplot2::theme_bw() +
      ggplot2::xlab("German contribution (bn Euro)") + ggplot2::ylab("Share supporting") +
      ggplot2::theme(legend.position = "bottom"),
    ggplot2::ggplot(s2, ggplot2::aes(.data$amounts, .data$support, color = .data$Multilateralism)) +
      ggplot2::geom_line() + ggplot2::ylim(0, 1) + ggplot2::theme_bw() +
      ggplot2::xlab("German contribution (bn  Euro)") + ggplot2::ylab("Share supporting") +
      ggplot2::theme(legend.position = "bottom") + ggplot2::ylab(""),
    ggplot2::ggplot(s3, ggplot2::aes(.data$amounts, .data$support, color = .data$Costs)) +
      ggplot2::geom_line() + ggplot2::ylim(0, 1) + ggplot2::theme_bw() +
      ggplot2::xlab("German contribution (mio vaccines)") + ggplot2::ylab("Share supporting") +
      ggplot2::theme(legend.position = "bottom"),
    ggplot2::ggplot(s4, ggplot2::aes(.data$amounts, .data$support, color = .data$Multilateralism)) +
      ggplot2::geom_line() + ggplot2::ylim(0, 1) + ggplot2::theme_bw() +
      ggplot2::xlab("German contribution (mio vaccines)") + ggplot2::ylab("Share supporting") +
      ggplot2::theme(legend.position = "bottom") + ggplot2::ylab(""),
    nrow = 2,
    ncol = 2
  )
}

#' @rdname make_figure_1
#' @export
make_fig_1 <- make_figure_1
