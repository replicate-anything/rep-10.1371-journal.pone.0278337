# Drop roxygen and short-name alias lines from replication source

Package R files include `#'` docs and `make_fig_1 <- make_figure_1`
aliases for exports; those are not needed in the Code tab display.

## Usage

``` r
clean_replication_source_lines(lines)
```

## Arguments

- lines:

  Character vector of source lines.

## Value

Filtered lines suitable for display.
