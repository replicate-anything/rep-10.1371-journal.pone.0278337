#' Build all report artifacts into `inst/report/artifacts/`
#'
#' Maintainer/CI helper: bakes precomputed outputs into the installed package so
#' Shiny **Display** can load them instantly. During development, Shiny falls
#' back to a live run when artifacts are missing — you do not need to call this
#' to use the app locally.
#'
#' @param output_dir Directory for generated files.
#' @return Invisibly, a manifest list.
#' @export
build_report <- function(output_dir = NULL) {
  if (is.null(output_dir)) {
    pkg_root <- system.file(package = "rep1371journalpone0278337")
    output_dir <- file.path(pkg_root, "report", "artifacts")
    if (!dir.exists(output_dir)) {
      output_dir <- file.path("inst", "report", "artifacts")
    }
  }
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  meta <- replication_meta()
  for (entry in meta$replications) {
    id <- entry$id
    obj <- run_replication(id)
    if (entry$type == "figure") {
      out <- file.path(output_dir, paste0(id, ".png"))
      grDevices::png(out, width = 10, height = 6, units = "in", res = 150)
      print(obj)
      grDevices::dev.off()
    } else {
      out <- file.path(output_dir, paste0(id, ".html"))
      if (is.data.frame(obj)) {
        writeLines(format_table_1(obj), out, useBytes = TRUE)
      } else {
        writeLines(as.character(obj), out, useBytes = TRUE)
      }
    }
  }

  manifest <- list(
    built = as.character(Sys.time()),
    package = "rep1371journalpone0278337",
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
