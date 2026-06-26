#' Format replication outputs for display
#'
#' @name format_outputs
NULL

#' Format a figure for display
#'
#' Pass-through for ggplot objects produced by `make_figure_*()` (Figures 1–8).
#'
#' @param object ggplot object from the corresponding [make_figure_1()] (etc.).
#' @rdname format_figure_1
#' @export
format_figure_1 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_1 <- format_figure_1

#' @rdname format_figure_1
#' @export
format_figure_2 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_2 <- format_figure_2

#' @rdname format_figure_1
#' @export
format_figure_3 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_3 <- format_figure_3

#' @rdname format_figure_1
#' @export
format_figure_4 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_4 <- format_figure_4

#' @rdname format_figure_1
#' @export
format_figure_5 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_5 <- format_figure_5

#' @rdname format_figure_1
#' @export
format_figure_6 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_6 <- format_figure_6

#' @rdname format_figure_1
#' @export
format_figure_7 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_7 <- format_figure_7

#' @rdname format_figure_1
#' @export
format_figure_8 <- function(object, ...) object

#' @rdname format_figure_1
#' @export
format_fig_8 <- format_figure_8

#' Format Table 1 for display
#'
#' @param object Data frame from [make_table_1()].
#' @rdname format_table_1
#' @export
format_table_1 <- function(object, ...) {
  knitr::kable(object, format = "html", digits = 2, row.names = FALSE)
}

#' @rdname format_table_1
#' @export
format_tab_1 <- format_table_1

#' Format Table 2 for display
#'
#' @param object `kableExtra` table from [make_table_2()].
#' @rdname format_table_2
#' @export
format_table_2 <- function(object, ...) {
  paste(as.character(object), collapse = "\n")
}

#' @rdname format_table_2
#' @export
format_tab_2 <- format_table_2
