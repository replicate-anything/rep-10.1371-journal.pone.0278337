test_that("get_code wires data and includes make source for fig_1", {
  skip_if_not_installed("rep1371journalpone0278337")
  lines <- rep1371journalpone0278337::get_code("fig_1")
  code <- paste(lines, collapse = "\n")
  expect_true(grepl("library(rep1371journalpone0278337)", code, fixed = TRUE))
  expect_true(grepl("library(dplyr)", code, fixed = TRUE))
  expect_true(grepl("library(ggplot2)", code, fixed = TRUE))
  expect_true(grepl("make_figure_1", code, fixed = TRUE))
  expect_true(grepl("wave4_conjoint", code, fixed = TRUE))
  expect_true(grepl("obj <- make_figure_1(wave4_conjoint)", code, fixed = TRUE))
  expect_true(grepl("obj <- format_figure_1(obj)", code, fixed = TRUE))
  expect_true(grepl("# --- R/make_figure_1.R ---", code, fixed = TRUE))
  expect_false(any(grepl("^\\s*#'", lines)))
  expect_false(grepl("make_fig_1 <- make_figure_1", code, fixed = TRUE))
  expect_false(grepl("@export", code, fixed = TRUE))
})

test_that("get_code wires two datasets for tab_2", {
  skip_if_not_installed("rep1371journalpone0278337")
  lines <- rep1371journalpone0278337::get_code("tab_2")
  code <- paste(lines, collapse = "\n")
  expect_true(grepl("make_table_2", code, fixed = TRUE))
  expect_true(grepl("wave2_survey", code, fixed = TRUE))
  expect_true(grepl("vignette_labels", code, fixed = TRUE))
  expect_true(grepl("survey = wave2_survey", code, fixed = TRUE))
  expect_true(grepl("obj <- make_table_2(", code, fixed = TRUE))
})

test_that("every table and figure replication has get_code output", {
  skip_if_not_installed("rep1371journalpone0278337")
  reps <- rep1371journalpone0278337::list_replications()
  ids <- vapply(reps, function(x) as.character(x$id), character(1))
  types <- vapply(reps, function(x) as.character(x$type %||% ""), character(1))
  display_ids <- ids[types %in% c("figure", "table")]
  expect_gt(length(display_ids), 0)
  for (id in display_ids) {
    lines <- rep1371journalpone0278337::get_code(id)
    expect_gt(length(lines), 10, label = id)
    expect_true(any(grepl(paste0("Replication: ", id), lines, fixed = TRUE)), label = id)
  }
})

test_that("run_replication matches get_code wiring for fig_2", {
  skip_if_not_installed("rep1371journalpone0278337")
  p <- rep1371journalpone0278337::run_replication("fig_2")
  expect_true(inherits(p, "ggplot"))
  code <- paste(rep1371journalpone0278337::get_code("fig_2"), collapse = "\n")
  expect_true(grepl("make_figure_2\\(wave4_conjoint\\)", code))
})
