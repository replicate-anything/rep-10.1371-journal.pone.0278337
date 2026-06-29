#' Resolve the artifact output directory
#'
#' Writes to `inst/report/artifacts/` when building from a package source tree
#' so [load_artifact()] and pkgdown can find files during development.
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
#' @return Invisibly, a manifest list.
#' @export
build_report <- function(output_dir = NULL, ids = NULL) {
  output_dir <- artifact_output_dir(output_dir)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  meta <- replication_meta()
  entries <- meta$replications
  if (!is.null(ids)) {
    ids <- as.character(ids)
    entries <- entries[vapply(entries, function(x) x$id %in% ids, logical(1))]
    if (length(entries) == 0) {
      stop("No matching replication ids in replication.yml.", call. = FALSE)
    }
  }
  for (entry in entries) {
    id <- entry$id
    obj <- run_replication(id)
    if (identical(entry$type, "figure")) {
      out <- file.path(output_dir, paste0(id, ".png"))
      grDevices::png(out, width = 10, height = 6, units = "in", res = 150)
      print(obj)
      grDevices::dev.off()
    } else {
      out <- file.path(output_dir, paste0(id, ".html"))
      writeLines(paste(as.character(obj), collapse = "\n"), out, useBytes = TRUE)
    }
  }

  manifest <- list(
    built = as.character(Sys.time()),
    package = pkg_name(),
    artifacts = list.files(output_dir, full.names = FALSE)
  )
  jsonlite::write_json(
    manifest,
    file.path(dirname(output_dir), "manifest.json"),
    pretty = TRUE,
    auto_unbox = TRUE
  )
  invisible(manifest)
}
