pkg <- normalizePath(".", winslash = "/", mustWork = TRUE)
devtools::load_all(pkg, quiet = TRUE)
df <- rep1371journalpone0278337::wave4_conjoint
df_4 <- dplyr::mutate(df, x = .data$cash_billions)

LL <- function(a = 240, b = -11, c = 41, g = 0.8, k = 4, sigma = 16) {
  R <- mapply(
    rep1371journalpone0278337:::structural_lik_x,
    df_4$x,
    MoreArgs = list(
      sigma = sigma, a = a, b = b, c = c, g = g, k = k,
      ZT = df_4$trading_importance,
      ZR = df_4$risk,
      ZY = df_4$others_giving,
      Zy = df_4$others_average
    )
  )
  -sum(log(R))
}

LLv <- function(a = 240, b = -11, c = 41, g = 0.8, k = 4, sigma = 16) {
  mu <- rep1371journalpone0278337:::structural_maxx(
    a, b, c, g, k,
    df_4$trading_importance,
    df_4$risk,
    df_4$others_giving,
    df_4$others_average
  )
  -sum(log(stats::dnorm(df_4$x, mu, sd = sigma)))
}

cat("mapply LL eval:\n")
print(system.time(v1 <- LL()))
cat("vectorized LL eval:\n")
print(system.time(v2 <- LLv()))
cat("same value:", isTRUE(all.equal(v1, v2)), "\n")
cat("length mapply result internals - R per call:\n")
R1 <- mapply(
  rep1371journalpone0278337:::structural_lik_x,
  df_4$x[1:3],
  MoreArgs = list(
    sigma = 16, a = 240, b = -11, c = 41, g = 0.8, k = 4,
    ZT = df_4$trading_importance,
    ZR = df_4$risk,
    ZY = df_4$others_giving,
    Zy = df_4$others_average
  )
)
cat("dim:", paste(dim(R1), collapse = "x"), "\n")

cat("\nfull make_table_1:\n")
print(system.time(rep1371journalpone0278337::make_table_1()))
