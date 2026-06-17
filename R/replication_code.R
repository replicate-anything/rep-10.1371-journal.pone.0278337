#' Read R source for a replication function from the package tree
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

#' @keywords internal
replication_entry_by_id <- function(id) {
  meta <- replication_meta()
  entries <- c(meta$prep %||% list(), meta$replications %||% list())
  match <- entries[vapply(entries, function(x) identical(x$id, id), logical(1))]
  if (length(match) == 0) {
    stop("Replication ", id, " not found.", call. = FALSE)
  }
  match[[1]]
}

#' @keywords internal
is_package_dataset <- function(name) {
  is.character(name) &&
    length(name) == 1L &&
    nzchar(name) &&
    !grepl("[/\\\\]", name) &&
    !grepl("\\.[a-zA-Z0-9]+$", name)
}

#' @keywords internal
build_data_wiring_lines <- function(entry, package = pkg_name()) {
  data_names <- entry$data
  if (is.null(data_names)) {
    return(c(paste0("library(", package, ")"), ""))
  }

  lines <- c(paste0("library(", package, ")"), "")

  if (length(data_names) == 1L && is_package_dataset(data_names[[1]])) {
    nm <- data_names[[1]]
    return(c(lines, paste0(nm, " <- ", package, "::", nm), ""))
  }

  if (length(data_names) == 1L) {
    return(c(
      lines,
      paste0("# data: ", data_names[[1]]),
      ""
    ))
  }

  arg_names <- if (identical(entry$make, "make_table_2")) {
    c("survey", "labels")
  } else {
    as.character(data_names)
  }

  for (i in seq_along(data_names)) {
    nm <- data_names[[i]]
    arg <- arg_names[[i]]
    lines <- c(lines, paste0(arg, " <- ", package, "::", nm))
  }
  c(lines, "")
}

#' @keywords internal
build_run_lines <- function(entry, package = pkg_name()) {
  make_fn <- entry$make %||% entry$code
  data_names <- entry$data
  fmt <- entry$format %||% NULL

  if (is.null(entry$make)) {
    code_fn <- entry$code
    if (!is.null(data_names) && length(data_names) == 1L) {
      if (is_package_dataset(data_names[[1]])) {
        call_line <- paste0("result <- ", package, "::", code_fn, "(", data_names[[1]], ")")
      } else {
        call_line <- paste0(
          'result <- ', package, '::', code_fn, '("', data_names[[1]], '")'
        )
      }
    } else {
      call_line <- paste0("result <- ", package, "::", code_fn, "()")
    }
    return(c(call_line, "result"))
  }

  call_line <- if (is.null(data_names)) {
    paste0("obj <- ", package, "::", make_fn, "()")
  } else if (length(data_names) == 1L && is_package_dataset(data_names[[1]])) {
    paste0("obj <- ", package, "::", make_fn, "(", data_names[[1]], ")")
  } else if (identical(make_fn, "make_table_2")) {
    paste0(
      "obj <- ", package, "::", make_fn,
      "(survey = ", data_names[[1]], ", labels = ", data_names[[2]], ")"
    )
  } else {
    paste0("obj <- ", package, "::", make_fn, "(", paste(data_names, collapse = ", "), ")")
  }

  lines <- call_line
  if (!is.null(fmt) && nzchar(fmt)) {
    lines <- c(lines, paste0("obj <- ", package, "::", fmt, "(obj)"))
  }
  c(lines, "obj")
}

#' Retrieve replication code for display
#'
#' Returns the relevant `make_*` (or prep) source file plus YAML-wired data
#' loading and run lines, matching how [run_replication()] executes the entry.
#'
#' @param id Replication id from `replication.yml` (e.g. `"fig_1"`).
#' @return Character vector of source lines.
#' @export
get_code <- function(id) {
  entry <- replication_entry_by_id(id)
  package <- pkg_name()
  source_name <- entry$make %||% entry$code

  if (is.null(source_name) || !nzchar(source_name)) {
    stop("Replication ", id, " has no make/code entry.", call. = FALSE)
  }

  header <- c(
    paste0("# Replication: ", id),
    if (!is.null(entry$label) && nzchar(entry$label)) paste0("# ", entry$label) else NULL,
    if (!is.null(entry$description) && nzchar(entry$description)) {
      paste0("# ", entry$description)
    } else {
      NULL
    },
    ""
  )
  header <- header[!vapply(header, is.null, logical(1))]

  source_lines <- read_replication_source(source_name, package)
  if (length(source_lines) == 0) {
    stop(
      "Could not find source for ", source_name,
      ". Run data-raw/sync_replication_code.R to populate inst/replication_code/.",
      call. = FALSE
    )
  }

  lines <- c(
    header,
    build_data_wiring_lines(entry, package),
    paste0("# --- R/", source_name, ".R ---"),
    source_lines,
    "",
    "# --- run (from replication.yml) ---",
    build_run_lines(entry, package)
  )

  lines
}
