if (!file.exists("DESCRIPTION")) {
  stop("Run from package root: Rscript data-raw/sync_replication_code.R", call. = FALSE)
}

copy_sources <- function() {
  r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
  keep <- grepl(
    "^(make_|prep_data|format_outputs)",
    basename(r_files)
  )
  r_files <- r_files[keep]

  out_dir <- file.path("inst", "replication_code")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  for (path in r_files) {
    dest <- file.path(out_dir, basename(path))
    file.copy(path, dest, overwrite = TRUE)
  }

  message("Synced ", length(r_files), " file(s) to inst/replication_code/")
}

copy_sources()
