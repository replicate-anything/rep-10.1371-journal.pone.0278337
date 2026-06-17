test_that("package data loads", {
  skip_if_not_installed("rep1371journalpone0278337")
  data("wave4_conjoint", package = "rep1371journalpone0278337", envir = environment())
  data("wave2_survey", package = "rep1371journalpone0278337", envir = environment())
  data("vignette_labels", package = "rep1371journalpone0278337", envir = environment())
  expect_true(nrow(wave4_conjoint) > 100)
  expect_true(nrow(wave2_survey) > 100)
  expect_true(nrow(vignette_labels) > 0)
})

test_that("make_figure_1 returns a plot object", {
  skip_if_not_installed("rep1371journalpone0278337")
  p <- rep1371journalpone0278337::make_figure_1()
  expect_true(inherits(p, "ggplot") || inherits(p, "gtable"))
})

test_that("make_table_1 returns six structural parameters", {
  skip_if_not_installed("rep1371journalpone0278337")
  tbl <- rep1371journalpone0278337::make_table_1()
  expect_s3_class(tbl, "data.frame")
  expect_equal(nrow(tbl), 6)
  expect_true(all(c("estimate", "std.error", "parameter") %in% names(tbl)))
  expect_equal(tbl$parameter[[1]], "\u03b1")
})

test_that("make_table_2 returns a displayable table", {
  skip_if_not_installed("rep1371journalpone0278337")
  skip_if_not_installed("modelsummary")
  tbl <- rep1371journalpone0278337::make_table_2()
  expect_true(inherits(tbl, "knitr_kable") || inherits(tbl, "character"))
})

test_that("list_replications reads yaml entries", {
  skip_if_not_installed("rep1371journalpone0278337")
  reps <- rep1371journalpone0278337::list_replications()
  ids <- vapply(reps, function(x) x$id, character(1))
  expect_true("fig_1" %in% ids)
  expect_true("tab_2" %in% ids)
  expect_true("prep_data" %in% ids)
})

test_that("run_replication produces figure 2", {
  skip_if_not_installed("rep1371journalpone0278337")
  p <- rep1371journalpone0278337::run_replication("fig_2")
  expect_true(inherits(p, "ggplot"))
})

test_that("prep_data_tab_2 reshapes conjoint rows", {
  skip_if_not_installed("rep1371journalpone0278337")
  long <- rep1371journalpone0278337::prep_data_tab_2()
  expect_true(nrow(long) > nrow(rep1371journalpone0278337::wave2_survey))
  expect_true(all(c("vignr", "rating", "outcome", "treatment_video") %in% names(long)))
})
