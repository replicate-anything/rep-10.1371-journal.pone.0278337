# Dot-and-whisker plot for marginal effects

Dot-and-whisker plot for marginal effects

## Usage

``` r
plot_marginal_effects(results, group_var = NULL, flip_axes = FALSE)
```

## Arguments

- results:

  Output of
  [`fit_marginal_effects()`](https://replicate-anything.github.io/rep_10.1371_journal.pone.0278337/reference/fit_marginal_effects.md)
  or
  [`fit_marginal_effects_by()`](https://replicate-anything.github.io/rep_10.1371_journal.pone.0278337/reference/fit_marginal_effects_by.md).

- group_var:

  Grouping column for dodged plots (`NULL` for a single series).

- flip_axes:

  Use horizontal treatment labels.

## Value

A ggplot object.
