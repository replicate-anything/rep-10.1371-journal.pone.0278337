# Read R source for a replication function from the package tree

Read R source for a replication function from the package tree

## Usage

``` r
read_replication_source(name, package = pkg_name())
```

## Arguments

- name:

  Base name without `.R` (e.g. `"make_figure_1"`).

- package:

  Package name.

## Value

Character vector of source lines, or empty if not found.
