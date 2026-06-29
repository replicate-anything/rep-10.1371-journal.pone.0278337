# Build all report artifacts into `inst/report/artifacts/`

Maintainer/CI helper: bakes precomputed outputs into the installed
package so Shiny **Display** can load them instantly. During
development, Shiny falls back to a live run when artifacts are missing —
you do not need to call this to use the app locally.

## Usage

``` r
build_report(output_dir = NULL, ids = NULL)
```

## Arguments

- output_dir:

  Directory for generated files.

- ids:

  Optional replication ids to build (e.g. `"tab_2"`). Default: all
  entries in `replication.yml`.

## Value

Invisibly, a manifest list.
