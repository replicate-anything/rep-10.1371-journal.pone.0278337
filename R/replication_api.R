pkg_name <- function() "rep1371journalpone0278337"

`%||%` <- function(a, b) if (is.null(a)) b else a

#' Package source or installation root
#' @keywords internal
package_root <- function() {
  getNamespaceInfo(asNamespace(pkg_name()), "path")
}

#' Path to a baked artifact file under `inst/report/artifacts/`
#'
#' @param id Replication id.
#' @param ext File extension (`png`, `html`, `rds`, ...).
#' @keywords internal
artifact_path <- function(id, ext) {
  fname <- paste0(id, ".", ext)

  installed <- system.file("report", "artifacts", fname, package = pkg_name())
  if (nzchar(installed) && file.exists(installed)) {
    return(installed)
  }

  pkg_artifact <- file.path(
    package_root(),
    "inst",
    "report",
    "artifacts",
    fname
  )
  if (file.exists(pkg_artifact)) {
    return(normalizePath(pkg_artifact, winslash = "/", mustWork = FALSE))
  }

  NULL
}

#' Read artifact bytes from a resolved path
#' @keywords internal
read_artifact_at_path <- function(path) {
  ext <- tolower(tools::file_ext(path))
  switch(
    ext,
    html = paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n"),
    rds = readRDS(path),
    path
  )
}

#' Load a dataset or object from this package
#'
#' LazyData objects are not visible in the package namespace; use `::` access.
#'
#' @param name Object name.
#' @param package Package name.
#' @return The requested object.
#' @keywords internal
get_package_object <- function(name, package = pkg_name()) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop("Package ", package, " is not installed.", call. = FALSE)
  }
  call_obj <- call("::", package, name)
  eval(call_obj, envir = parent.frame())
}
