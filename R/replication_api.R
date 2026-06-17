pkg_name <- function() "rep1371journalpone0278337"

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

  make_fn <- get(entry$make, mode = "function", envir = asNamespace("rep1371journalpone0278337"))
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

  if (!is.null(entry$format) && nzchar(entry$format)) {
    fmt <- get(entry$format, mode = "function", envir = asNamespace("rep1371journalpone0278337"))
    return(fmt(obj))
  }
  obj
}

#' Load a precomputed artifact from `inst/report/artifacts/`
#'
#' @param id Replication id.
#' @return File path or loaded object.
#' @export
load_artifact <- function(id) {
  path <- system.file(
    "report", "artifacts", paste0(id, ".png"),
    package = "rep1371journalpone0278337"
  )
  if (nzchar(path) && file.exists(path)) {
    return(path)
  }
  path <- system.file(
    "report", "artifacts", paste0(id, ".html"),
    package = "rep1371journalpone0278337"
  )
  if (nzchar(path) && file.exists(path)) {
    return(paste(readLines(path, warn = FALSE), collapse = "\n"))
  }
  path <- system.file(
    "report", "artifacts", paste0(id, ".rds"),
    package = "rep1371journalpone0278337"
  )
  if (nzchar(path) && file.exists(path)) {
    return(readRDS(path))
  }
  NULL
}
