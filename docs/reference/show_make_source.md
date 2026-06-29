# Emit a collapsible code block with the underlying `make_*` source

Emit a collapsible code block with the underlying `make_*` source

## Usage

``` r
show_make_source(make_fn)
```

## Arguments

- make_fn:

  Base name of the make function (e.g. `"make_figure_1"`).

## Value

Invisibly `NULL`; writes markdown/HTML via
[`cat()`](https://rdrr.io/r/base/cat.html).
