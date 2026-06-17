test_that("inst/replication_code mirrors canonical R sources", {
  skip_if_not_installed("rep1371journalpone0278337")
  pkg_root <- normalizePath(
    file.path(testthat::test_path(".."), ".."),
    winslash = "/",
    mustWork = FALSE
  )
  r_dir <- file.path(pkg_root, "R")
  inst_dir <- file.path(pkg_root, "inst", "replication_code")
  skip_if_not(dir.exists(inst_dir), "inst/replication_code missing")

  mirrored <- list.files(
    r_dir,
    pattern = "^(make_|prep_data|format_outputs).*\\.R$",
    full.names = FALSE
  )
  expect_gt(length(mirrored), 0)

  for (name in mirrored) {
    r_path <- file.path(r_dir, name)
    inst_path <- file.path(inst_dir, name)
    expect_true(file.exists(inst_path), label = name)
    expect_equal(
      readLines(r_path, warn = FALSE),
      readLines(inst_path, warn = FALSE),
      label = name
    )
  }
})

test_that("inst/replication.yml matches package root replication.yml", {
  skip_if_not_installed("rep1371journalpone0278337")
  pkg_root <- normalizePath(
    file.path(testthat::test_path(".."), ".."),
    winslash = "/",
    mustWork = FALSE
  )
  root_yml <- file.path(pkg_root, "replication.yml")
  inst_yml <- file.path(pkg_root, "inst", "replication.yml")
  skip_if_not(file.exists(root_yml) && file.exists(inst_yml))
  expect_equal(
    readLines(root_yml, warn = FALSE),
    readLines(inst_yml, warn = FALSE)
  )
})
