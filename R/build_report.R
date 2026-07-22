#' Resolve the artifact output directory
#'
#' Writes to `inst/report/artifacts/` when building from a package source tree
#' so Shiny Display / pkgdown can find files during development.
#'
#' @param output_dir Optional override.
#' @return Normalized directory path.
#' @keywords internal
artifact_output_dir <- function(output_dir = NULL) {
  if (!is.null(output_dir)) {
    return(output_dir)
  }
  file.path(package_root(), "inst", "report", "artifacts")
}

#' Build all report artifacts into `inst/report/artifacts/`
#'
#' Maintainer/CI helper: bakes precomputed outputs into the installed package so
#' Shiny **Display** can load them instantly. During development, Shiny falls
#' back to a live run when artifacts are missing — you do not need to call this
#' to use the app locally.
#'
#' @param output_dir Directory for generated files.
#' @param ids Optional replication ids to build (e.g. `"tab_2"`). Default: all
#'   entries in `replication.yml`.
#' @param install_deps Install missing CRAN dependencies when `TRUE`.
#' @return Invisibly, a manifest list.
#' @export
build_report <- function(output_dir = NULL, ids = NULL, install_deps = TRUE) {
  if (!requireNamespace("replicateEverything", quietly = TRUE)) {
    stop(
      "build_report() requires replicateEverything. ",
      "Install it or call the legacy make_* functions directly.",
      call. = FALSE
    )
  }
  replicateEverything::build_study_outputs(
    pkg_name(),
    install_deps = install_deps,
    ids = ids,
    output_dir = artifact_output_dir(output_dir)
  )
}
