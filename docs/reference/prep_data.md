# Rebuild analysis datasets from the raw survey export

Mirrors the `prep_data` chunk in the original `analysis.Rmd`. Requires
`combined.csv` from the vaccine solidarity repository.

## Usage

``` r
prep_data(combined_path = "combined.csv")
```

## Arguments

- combined_path:

  Path to `combined.csv`.

## Value

A list with `wave4_conjoint` and `wave2_survey` data frames.
