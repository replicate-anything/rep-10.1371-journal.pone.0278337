# Retrieve replication code for display

Returns the relevant `make_*` (or prep) source file plus YAML-wired data
loading and run lines, matching how
[`run_replication()`](https://replicate-anything.github.io/rep_10.1371_journal.pone.0278337/reference/run_replication.md)
executes the entry.

## Usage

``` r
get_code(id)
```

## Arguments

- id:

  Replication id from `replication.yml` (e.g. `"fig_1"`).

## Value

Character vector of source lines.
