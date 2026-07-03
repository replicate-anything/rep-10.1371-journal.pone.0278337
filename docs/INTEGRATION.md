# Integration: package-backed studies in the registry

## Design principle

| Layer | Responsibility |
|----|----|
| **Registry** (`registry/papers/<folder>/`) | **Stub only**: DOI metadata + `paper.package` link for the index |
| **Study package** (`rep_*`) | Code, data, `replication.yml` (full), [`build_report()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/build_report.md) artifacts |
| **replicateEverything** | Merge package yaml; dispatch Run/Code/Display to the package |
| **Shiny** | Same as replicateEverything (no registry `code/` or `artifacts/`) |

## Registry stub (all you need in `registry/papers/<folder>/`)

``` yaml
paper:
  doi: https://doi.org/10.1371/journal.pone.0278337
  title: "..."
  journal: PLOS ONE
  year: 2022
  authors: ...
  package: rep1371journalpone0278337
  package_folder: rep-10.1371_journal.pone.0278337   # monorepo sibling (optional)
  package_repo: replicate-anything/rep-10.1371_journal.pone.0278337
  package_ref: main
repo: replicate-anything/rep-10.1371_journal.pone.0278337
```

No `replications:`, `code/`, `data/`, or `artifacts/` in the registry.

`replicateEverything::enrich_package_replication_meta()` fills
`replications` from the package `replication.yml` (GitHub or installed
package).

## What lives in the study package

| Need | Location |
|----|----|
| Replication list | `replication.yml` → `inst/replication.yml` |
| Analysis code | `R/make_*.R` → `inst/replication_code/` |
| Data | `data/` (LazyData) |
| Display artifacts | `inst/report/artifacts/` via [`build_report()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/build_report.md) |
| Vignette / pkgdown | package vignettes |

## Shiny & replicateEverything behavior

- **Display** → `package::load_artifact(id)` (reads
  `inst/report/artifacts/`)
- **Code** → `package::get_code(id)` or raw GitHub
  `inst/replication_code/`
- **Run** → `package::run_replication(id)` (requires installed/loaded
  package)

Registry `scripts/build_artifacts.R` **skips** package-backed papers;
run
[`build_report()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/build_report.md)
in the study package instead.

## Required package API

- [`list_replications()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/list_replications.md),
  [`replication_meta()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/replication_meta.md)
- `run_replication(id)`
- `load_artifact(id)`, `artifact_file(id)`
- `get_code(id)`,
  [`build_report()`](https://replicate-anything.github.io/rep-10.1371_journal.pone.0278337/reference/build_report.md)
