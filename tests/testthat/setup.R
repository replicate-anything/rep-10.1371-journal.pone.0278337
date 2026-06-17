pkg_root <- normalizePath(file.path(testthat::test_path(".."), ".."), winslash = "/", mustWork = FALSE)

if (!requireNamespace("rep1371journalpone0278337", quietly = TRUE)) {
  if (requireNamespace("devtools", quietly = TRUE) && file.exists(file.path(pkg_root, "DESCRIPTION"))) {
    devtools::load_all(pkg_root, quiet = TRUE)
  }
}
