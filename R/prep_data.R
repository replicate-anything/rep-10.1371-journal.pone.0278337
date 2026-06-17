#' Rebuild analysis datasets from the raw survey export
#'
#' Mirrors the `prep_data` chunk in the original `analysis.Rmd`. Requires
#' `combined.csv` from the vaccine solidarity repository.
#'
#' @param combined_path Path to `combined.csv`.
#' @return A list with `wave4_conjoint` and `wave2_survey` data frames.
#' @export
prep_data <- function(combined_path = "combined.csv") {
  if (!file.exists(combined_path)) {
    stop(
      "Raw file not found: ", combined_path,
      ". Place combined.csv from vaccine_solidarity/1_input/ or pass a path.",
      call. = FALSE
    )
  }

  vign_values <- vignette_values()

  main_df <- utils::read.csv(combined_path, stringsAsFactors = FALSE) |>
    dplyr::mutate(
      party = factor(
        .data$party_id,
        1:9,
        c(
          "CDU.CSU", "CDU.CSU", "SPD", "AFD", "Greens",
          "FDP", "Left", "Other", "No party"
        )
      )
    ) |>
    dplyr::group_by(.data$ID) |>
    dplyr::mutate(
      migration_background = mean(.data$migration_background, na.rm = TRUE)
    ) |>
    dplyr::ungroup()

  wave2_survey <- main_df |>
    dplyr::filter(.data$wave == 2) |>
    dplyr::select(
      dplyr::all_of(c(
        "ID", "solidarity_behaviour", "solidarity_attitude", "treatment_video",
        dplyr::starts_with("c_0031"),
        dplyr::starts_with("c_0032"),
        dplyr::starts_with("vignette"),
        dplyr::starts_with("conjoint_")
      ))
    )

  w4 <- main_df |>
    dplyr::filter(.data$wave == 4) |>
    dplyr::select(
      .data$group, .data$ID,
      .data$perspective_fed_indian, .data$perspective_fed_german,
      .data$vaccinated, .data$party, .data$migration_background,
      .data$run1_exp8, .data$exp7_money1, .data$exp7_doses1,
      .data$run2_exp8, .data$exp7_money2, .data$exp7_doses2
    )

  wave4_conjoint <- dplyr::bind_rows(
    w4 |>
      dplyr::mutate(vignr = as.numeric(.data$run1_exp8), round = 1) |>
      dplyr::rename(cash = .data$exp7_money1, doses = .data$exp7_doses1),
    w4 |>
      dplyr::mutate(vignr = as.numeric(.data$run2_exp8), round = 2) |>
      dplyr::rename(cash = .data$exp7_money2, doses = .data$exp7_doses2)
  ) |>
    dplyr::left_join(vign_values, by = "vignr") |>
    dplyr::filter(.data$group != 3) |>
    dplyr::mutate(
      id = .data$ID,
      others_number = (.data$deal == 1 | .data$deal == 3) * 2 +
        (.data$deal == 2 | .data$deal == 4) * 4,
      others_giving = (.data$deal == 1 | .data$deal == 2) * 2 +
        (.data$deal == 3 | .data$deal == 4) * 4,
      others_average = dplyr::if_else(
        .data$others_number == 0,
        0,
        .data$others_giving / .data$others_number
      ),
      deal = factor(.data$deal, deal_labels, names(deal_labels)),
      risk_factor = factor(.data$risk, 0:1, c("Low", "High")),
      trading_factor = factor(
        .data$trading_importance,
        0:1,
        c("Low", "High")
      ),
      risk = .data$risk - mean(.data$risk),
      trading_importance = .data$trading_importance - mean(.data$trading_importance),
      others_number_norm = .data$others_number - mean(.data$others_number),
      others_giving_norm = .data$others_giving - mean(.data$others_giving),
      cash_billions = .data$cash * 1000,
      cash_billions_log = log(1 + .data$cash_billions)
    ) |>
    dplyr::left_join(wave2_survey, by = "ID")

  list(
    wave4_conjoint = wave4_conjoint,
    wave2_survey = wave2_survey
  )
}
