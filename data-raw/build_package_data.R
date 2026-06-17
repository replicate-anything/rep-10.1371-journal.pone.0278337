if (!file.exists("DESCRIPTION")) {
  stop("Run from package root: Rscript data-raw/build_package_data.R", call. = FALSE)
}

read_study_csv <- function(name) {
  utils::read.csv(file.path("data-raw", paste0(name, ".csv")), stringsAsFactors = FALSE)
}

wave4_conjoint <- read_study_csv("wave4_conjoint")
wave2_survey <- read_study_csv("wave2_survey")
vignette_labels <- read_study_csv("vignette_labels")

dir.create("data", showWarnings = FALSE)
save(wave4_conjoint, file = "data/wave4_conjoint.rda", compress = "xz")
save(wave2_survey, file = "data/wave2_survey.rda", compress = "xz")
save(vignette_labels, file = "data/vignette_labels.rda", compress = "xz")

message("Wrote data/*.rda")
