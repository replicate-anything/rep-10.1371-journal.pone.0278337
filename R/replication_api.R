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

#' Resolve path to a precomputed artifact file
#'
#' @param id Replication id.
#' @return Character path, or `NULL` if not baked yet (run [build_report()]).
#' @export
artifact_file <- function(id) {
  for (ext in c("png", "html", "rds", "svg")) {
    path <- artifact_path(id, ext)
    if (!is.null(path)) {
      return(path)
    }
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

#' List available replications defined in `replication.yml`
#'
#' @return A list of replication metadata entries.
#' @export
list_replications <- function() {
  yml <- system.file("replication.yml", package = "rep1371journalpone0278337")
  if (!nzchar(yml)) {
    yml <- "replication.yml"
  }
  meta <- yaml::read_yaml(yml)
  c(meta$prep %||% list(), meta$replications %||% list())
}

#' Read package replication metadata
#'
#' @return Parsed contents of `replication.yml`.
#' @export
replication_meta <- function() {
  yml <- system.file("replication.yml", package = "rep1371journalpone0278337")
  if (!nzchar(yml)) {
    yml <- "replication.yml"
  }
  yaml::read_yaml(yml)
}

#' Run a named replication or prep step
#'
#' @param id Replication id from `replication.yml` (e.g. `"fig_1"`, `"prep_data"`).
#' @param install_deps Ignored; kept for compatibility with replicateEverything.
#' @return Analysis or display object.
#' @export
run_replication <- function(id, install_deps = FALSE) {
  meta <- replication_meta()
  entries <- c(meta$prep %||% list(), meta$replications %||% list())
  match <- entries[vapply(entries, function(x) identical(x$id, id), logical(1))]
  if (length(match) == 0) {
    stop("Replication ", id, " not found.", call. = FALSE)
  }
  entry <- match[[1]]

  if (identical(entry$id, "prep_data")) {
    return(prep_data())
  }
  if (identical(entry$id, "prep_data_tab_2")) {
    return(prep_data_tab_2())
  }

  make_fn <- get(entry$make, mode = "function", envir = asNamespace(pkg_name()))
  data_names <- entry$data
  if (is.null(data_names)) {
    obj <- make_fn()
  } else if (length(data_names) == 1) {
    dataset <- get_package_object(data_names[[1]])
    obj <- make_fn(dataset)
  } else {
    args <- lapply(data_names, get_package_object)
    if (identical(entry$make, "make_table_2")) {
      names(args) <- c("survey", "labels")
    }
    obj <- do.call(make_fn, args)
  }

  fmt <- get(entry$format, mode = "function", envir = asNamespace(pkg_name()))
  fmt(obj)
}

#' Load a precomputed display artifact from `inst/report/artifacts/`
#'
#' @param id Replication id.
#' @return For figures, a path to a PNG; for tables, an HTML string; or `NULL`.
#' @export
load_artifact <- function(id) {
  for (ext in c("png", "html", "rds", "svg")) {
    path <- artifact_path(id, ext)
    if (!is.null(path)) {
      return(read_artifact_at_path(path))
    }
  }
  NULL
}
