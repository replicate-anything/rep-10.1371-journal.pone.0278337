#' Reshape wave 2 conjoint tasks into long format for Table 2
#'
#' @param wave2_survey Wave 2 respondent-level data.
#' @param vignette_labels Vignette attribute lookup table.
#' @return Long-format conjoint data with demeaned attributes and ratings.
#' @export
prep_data_tab_2 <- function(
  wave2_survey = wave2_survey,
  vignette_labels = vignette_labels
) {
  conjoints <- dplyr::bind_rows(
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$c_0031_w2),
        outcome = .data$conjoint_choice1_exp3,
        rating = .data$conjoint_rating1_exp3,
        contest = 1,
        candidate = 1
      ),
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$c_0032_w2),
        outcome = .data$conjoint_choice1_exp3,
        rating = .data$conjoint_rating2_exp3,
        contest = 1,
        candidate = 2
      ),
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$vignette3),
        outcome = .data$conjoint_choice2_exp3,
        rating = .data$conjoint_rating3_exp3,
        contest = 2,
        candidate = 1
      ),
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$vignette4),
        outcome = .data$conjoint_choice2_exp3,
        rating = .data$conjoint_rating4_exp3,
        contest = 2,
        candidate = 2
      ),
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$vignette5),
        outcome = .data$conjoint_choice3_exp3,
        rating = .data$conjoint_rating5_exp3,
        contest = 3,
        candidate = 1
      ),
    wave2_survey |>
      dplyr::mutate(
        vignr = as.numeric(.data$vignette6),
        outcome = .data$conjoint_choice3_exp3,
        rating = .data$conjoint_rating6_exp3,
        contest = 3,
        candidate = 2
      )
  ) |>
    dplyr::select(
      .data$ID,
      .data$vignr,
      .data$outcome,
      .data$rating,
      .data$contest,
      .data$candidate,
      .data$treatment_video
    ) |>
    dplyr::mutate(
      outcome = dplyr::if_else(
        .data$candidate == 1,
        as.numeric(.data$outcome == "1"),
        as.numeric(.data$outcome == "2")
      )
    ) |>
    dplyr::left_join(vignette_labels, by = "vignr") |>
    dplyr::mutate(
      doses = factor(
        .data$vig_doses,
        0:3,
        c(
          "1 Million doses", "5 Million doses",
          "10 Million doses", "20 Million doses"
        )
      ),
      share = factor(
        .data$vig_dose_share,
        0:3,
        c(
          "1 % of the vaccines", "5 % of the vaccines",
          "10 % of the vaccines", "20 % of the vaccines"
        )
      ),
      number = factor(
        .data$vig_countries,
        0:2,
        c("20 countries", "80 countries", "160 countries")
      ),
      economic_benefits = factor(
        .data$vig_benefit_economic,
        0:1,
        c("Without economic importance", "With economic importance")
      ),
      health_benefits = factor(
        .data$vig_benefit_health,
        0:1,
        c("No risk of infection", "Risk of infection")
      )
    )

  conjoints |>
    dplyr::mutate(
      doses_norm = .data$vig_doses - mean(.data$vig_doses),
      number_norm = .data$vig_countries - mean(.data$vig_countries),
      share_norm = .data$vig_dose_share - mean(.data$vig_dose_share),
      economic_benefits = .data$vig_benefit_economic - mean(.data$vig_benefit_economic),
      health_benefits = .data$vig_benefit_health - mean(.data$vig_benefit_health)
    ) |>
    dplyr::group_by(.data$ID) |>
    dplyr::mutate(rating = .data$rating - mean(.data$rating)) |>
    dplyr::ungroup()
}
