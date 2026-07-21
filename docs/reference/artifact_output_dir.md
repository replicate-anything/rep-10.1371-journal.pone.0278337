# Resolve the artifact output directory

Writes to `inst/report/artifacts/` when building from a package source
tree so
[`load_artifact()`](https://replicate-anything.github.io/rep-10.1371-journal.pone.0278337/reference/load_artifact.md)
and pkgdown can find files during development.

## Usage

``` r
artifact_output_dir(output_dir = NULL)
```

## Arguments

- output_dir:

  Optional override.

## Value

Normalized directory path.
