#' Read R source for a replication function from the package tree
#'
#' Used by the vignette helpers. Shiny / replicateEverything read
#' `inst/replication_code/` via replicateEverything::get_code().
#'
#' @param name Base name without `.R` (e.g. `"make_figure_1"`).
#' @param package Package name.
#' @return Character vector of source lines, or empty if not found.
#' @keywords internal
read_replication_source <- function(name, package = pkg_name()) {
  inst_path <- system.file("replication_code", paste0(name, ".R"), package = package)
  if (nzchar(inst_path) && file.exists(inst_path)) {
    return(readLines(inst_path, warn = FALSE))
  }
  if (requireNamespace(package, quietly = TRUE)) {
    dev_path <- file.path(
      getNamespaceInfo(asNamespace(package), "path"),
      "R",
      paste0(name, ".R")
    )
    if (file.exists(dev_path)) {
      return(readLines(dev_path, warn = FALSE))
    }
  }
  character(0)
}

#' Drop roxygen and short-name alias lines from replication source
#'
#' Package R files include `#'` docs and `make_fig_1 <- make_figure_1` aliases
#' for exports; those are not needed in Code-tab-style display.
#'
#' @param lines Character vector of source lines.
#' @return Filtered lines suitable for display.
#' @keywords internal
clean_replication_source_lines <- function(lines) {
  if (!length(lines)) {
    return(lines)
  }
  is_roxygen <- grepl("^\\s*#'", lines)
  is_alias <- grepl(
    "^\\s*(make_fig_|make_tab_|format_fig_|format_tab_)\\d+\\s*<-\\s*",
    lines
  )
  lines[!is_roxygen & !is_alias]
}
