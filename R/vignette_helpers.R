#' Helpers for the package vignette
#'
#' @name vignette_helpers
#' @keywords internal
NULL

#' Show a precomputed table artifact in the vignette
#'
#' @param id Replication id (e.g. `"tab_1"`).
#' @return A `knitr::asis_output()` object.
#' @keywords internal
show_table_artifact <- function(id) {
  path <- NULL
  for (ext in c("html", "rds")) {
    path <- artifact_path(id, ext)
    if (!is.null(path)) {
      break
    }
  }
  html <- if (!is.null(path)) read_artifact_at_path(path) else NULL
  if (is.null(html) || !is.character(html)) {
    knitr::asis_output(paste0(
      "<p><em>No precomputed artifact for <code>", id, "</code>. ",
      "Run <code>build_report()</code> before rendering.</em></p>"
    ))
  } else {
    knitr::asis_output(html)
  }
}

#' Strip roxygen and alias lines from replication source for display
#'
#' @param lines Character vector of source lines.
#' @return Filtered lines.
#' @keywords internal
clean_replication_source <- function(lines) {
  lines <- lines[!grepl("^\\s*#'", lines)]
  lines <- lines[!grepl("^\\s*make_fig_\\d+\\s*<-", lines)]
  lines <- lines[!grepl("^\\s*make_tab_\\d+\\s*<-", lines)]
  lines <- lines[!grepl("^\\s*format_fig_\\d+\\s*<-", lines)]
  lines <- lines[!grepl("^\\s*format_tab_\\d+\\s*<-", lines)]
  lines
}

#' Emit a collapsible code block with the underlying `make_*` source
#'
#' @param make_fn Base name of the make function (e.g. `"make_figure_1"`).
#' @return Invisibly `NULL`; writes markdown/HTML via `cat()`.
#' @keywords internal
show_make_source <- function(make_fn) {
  path <- system.file(
    "replication_code",
    paste0(make_fn, ".R"),
    package = pkg_name()
  )
  if (!nzchar(path) || !file.exists(path)) {
    cat(
      "<p><em>Source file not found for <code>",
      make_fn,
      "</code>.</em></p>",
      sep = ""
    )
    return(invisible(NULL))
  }
  lines <- clean_replication_source(
    readLines(path, warn = FALSE, encoding = "UTF-8")
  )
  cat(
    "\n\n<p class=\"source-file\"><code>R/",
    make_fn,
    ".R</code></p>\n\n```r\n",
    paste(lines, collapse = "\n"),
    "\n```\n\n",
    sep = ""
  )
  invisible(NULL)
}
