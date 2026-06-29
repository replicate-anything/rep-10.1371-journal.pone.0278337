test_that("load_artifact reads package artifact html", {
  skip_if_not_installed("rep1371journalpone0278337")

  pkg_root <- getNamespaceInfo(asNamespace("rep1371journalpone0278337"), "path")
  tab_path <- file.path(pkg_root, "inst", "report", "artifacts", "tab_1.html")
  skip_if_not(file.exists(tab_path), "run build_report() to bake tab_1.html")

  html <- rep1371journalpone0278337::load_artifact("tab_1")
  expect_true(is.character(html))
  expect_gt(nchar(html), 100L)
  expect_true(grepl("<table", html, ignore.case = TRUE))
})

test_that("artifact_file resolves package artifact path", {
  skip_if_not_installed("rep1371journalpone0278337")

  pkg_root <- getNamespaceInfo(asNamespace("rep1371journalpone0278337"), "path")
  tab_path <- file.path(pkg_root, "inst", "report", "artifacts", "tab_1.html")
  skip_if_not(file.exists(tab_path), "run build_report() to bake tab_1.html")

  path <- rep1371journalpone0278337::artifact_file("tab_1")
  expect_equal(path, normalizePath(tab_path, winslash = "/", mustWork = FALSE))
})
