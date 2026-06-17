if (!file.exists("DESCRIPTION")) {
  stop("Run from package root: Rscript data-raw/sync_replication_code.R", call. = FALSE)
}

sync_replication_code <- function() {
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

  if (file.exists("replication.yml")) {
    file.copy("replication.yml", file.path("inst", "replication.yml"), overwrite = TRUE)
  }

  message(
    "Synced ", length(r_files), " R source(s) to inst/replication_code/",
    " and replication.yml to inst/"
  )
}

sync_replication_code()