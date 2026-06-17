#' Table 2 — additional analyses (wave 2 conjoint)
#'
#' @param survey Wave 2 survey data. Defaults to [wave2_survey].
#' @param labels Vignette labels. Defaults to [vignette_labels].
#' @return A `kableExtra` table object.
#' @export
make_table_2 <- function(survey = wave2_survey, labels = vignette_labels) {
  conjoints_norm <- prep_data_tab_2(survey, labels)

  models_treatments <- list(
    rating = estimatr::lm_robust(
      rating ~ treatment_video * vig_doses + treatment_video * vig_dose_share +
        treatment_video * vig_countries + treatment_video * vig_benefit_economic +
        treatment_video * vig_benefit_health,
      data = conjoints_norm
    ),
    choice = estimatr::lm_robust(
      outcome ~ treatment_video * vig_doses + treatment_video * vig_dose_share +
        treatment_video * vig_countries + treatment_video * vig_benefit_economic +
        treatment_video * vig_benefit_health,
      data = conjoints_norm
    )
  )

  coef_map <- c(
    "(Intercept)" = "Constant (Average rating)",
    "treatment_video" = "Video effect (given ungenerous agreement)",
    "vig_doses" = "German contribution",
    "vig_dose_share" = "German share",
    "vig_countries" = "Number of donors",
    "vig_benefit_economic" = "Economic benefits",
    "vig_benefit_health" = "Health benefits",
    "treatment_video:vig_doses" = "Video * Contribution",
    "treatment_video:vig_dose_share" = "Video * Share",
    "treatment_video:vig_countries" = "Video * Donors",
    "treatment_video:vig_benefit_economic" = "Video * Economics",
    "treatment_video:vig_benefit_health" = "Video * Health"
  )

  modelsummary::modelsummary(
    models_treatments,
    coef_map = coef_map,
    estimate = "{estimate}{stars}",
    statistic = "({std.error})",
    output = "kableExtra",
    stars = c("***" = 0.001, "**" = 0.01, "*" = 0.05),
    gof_map = c("r.squared", "adj.r.squared", "nobs", "rmse"),
    title = "Effects of treatment on drivers of support for agreements.",
    notes = "*** p<0.001; ** p<0.01; * p<0.05",
    colnames = c("rating", "choice")
  )
}

#' @rdname make_table_2
#' @export
make_tab_2 <- make_table_2
