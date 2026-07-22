test_that("baked tab_1 artifact exists for Display", {
  skip_if_not_installed("rep1371journalpone0278337")

  pkg_root <- getNamespaceInfo(asNamespace("rep1371journalpone0278337"), "path")
  tab_path <- file.path(pkg_root, "inst", "report", "artifacts", "tab_1.html")
  if (!file.exists(tab_path)) {
    tab_path <- system.file(
      "report", "artifacts", "tab_1.html",
      package = "rep1371journalpone0278337"
    )
  }
  skip_if_not(nzchar(tab_path) && file.exists(tab_path), "run build_report() to bake tab_1.html")

  html <- paste(readLines(tab_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  expect_gt(nchar(html), 100L)
  expect_true(grepl("<table", html, ignore.case = TRUE))
})

test_that("replicateEverything can load package artifact when registry is available", {
  skip_if_not_installed("rep1371journalpone0278337")
  skip_if_not_installed("replicateEverything")

  pkg_root <- getNamespaceInfo(asNamespace("rep1371journalpone0278337"), "path")
  tab_path <- file.path(pkg_root, "inst", "report", "artifacts", "tab_1.html")
  skip_if_not(file.exists(tab_path), "run build_report() to bake tab_1.html")

  path <- replicateEverything:::package_installed_artifact_path(
    "tab_1",
    "rep1371journalpone0278337"
  )
  expect_true(!is.null(path) && file.exists(path))
})
