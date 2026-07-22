# Integration: package-backed studies in the registry

## Design principle

| Layer | Responsibility |
|-------|----------------|
| **Registry** (`registry/studies/<folder>.yml`) | **Stub only**: DOI metadata + `paper.package` link for the index |
| **Study package** (`rep_*`) | Code, data, `replication.yml`, `make_*` / `format_*`, `build_report()` artifacts |
| **replicateEverything** | Merge package yaml; drive Display / Code / Run via its own verbs |
| **Shiny** | Same as replicateEverything (no registry `code/` or `artifacts/`) |

## Registry stub (all you need in `registry/studies/<folder>.yml`)

```yaml
paper:
  doi: https://doi.org/10.1371/journal.pone.0278337
  title: "..."
  journal: PLOS ONE
  year: 2022
  authors: ...
  package: rep1371journalpone0278337
  package_folder: rep-10.1371-journal.pone.0278337   # monorepo sibling (optional)
  package_repo: replicate-anything/rep-10.1371-journal.pone.0278337
  package_ref: main
repo: replicate-anything/rep-10.1371-journal.pone.0278337
```

No `replications:`, `code/`, `data/`, or `artifacts/` in the registry.

`replicateEverything` fills step lists from the package `replication.yml`
(GitHub or installed package).

## What lives in the study package

| Need | Location |
|------|----------|
| Replication list | `replication.yml` → `inst/replication.yml` |
| Analysis code | `R/make_*.R` → `inst/replication_code/` |
| Data | `data/` (LazyData) |
| Display artifacts | `inst/report/artifacts/` via `build_report()` |
| Vignette / pkgdown | package vignettes |

Do **not** export `run_replication()`, `list_replications()`, `load_artifact()`,
or `get_code()` from the study package. Those verbs live only in
**replicateEverything**.

## Shiny & replicateEverything behavior

- **Display** → `replicateEverything::load_artifact(doi, id)` (reads `inst/report/artifacts/`)
- **Code** → `replicateEverything::get_code(doi, id)` (from `inst/replication_code/` / repo)
- **Run** → `replicateEverything::run_replication(doi, id)` (calls package `make_*` / `format_*`)

Registry `scripts/build_artifacts.R` **skips** package-backed papers; run
`build_report()` in the study package instead.

## Study package surface

- Exported `make_*` / `format_*` named in yaml (plus shared helpers / data)
- Optional `build_report()` to bake Display artifacts
