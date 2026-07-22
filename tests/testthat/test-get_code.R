test_that("replicateEverything get_code wires data for fig_1", {
  skip_if_not_installed("rep1371journalpone0278337")
  skip_if_not_installed("replicateEverything")

  doi <- "10.1371/journal.pone.0278337"
  lines <- tryCatch(
    replicateEverything::get_code(doi, "fig_1"),
    error = function(e) NULL
  )
  skip_if(is.null(lines), "registry / monorepo options needed for get_code(doi, ...)")

  code <- paste(lines, collapse = "\n")
  expect_true(grepl("library(rep1371journalpone0278337)", code, fixed = TRUE))
  expect_true(grepl("make_figure_1", code, fixed = TRUE))
  expect_true(grepl("wave4_conjoint", code, fixed = TRUE))
  expect_false(any(grepl("^\\s*#'", lines)))
  expect_false(grepl("@export", code, fixed = TRUE))
})

test_that("installed package source is available for Code tab", {
  skip_if_not_installed("rep1371journalpone0278337")
  skip_if_not_installed("replicateEverything")

  lines <- replicateEverything:::read_installed_package_source(
    "make_figure_1",
    "rep1371journalpone0278337"
  )
  expect_gt(length(lines), 5)
  expect_true(any(grepl("make_figure_1", lines)))
})
