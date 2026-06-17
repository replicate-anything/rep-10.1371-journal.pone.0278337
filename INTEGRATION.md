# Integration plan: study-specific replication packages

This document describes how `rep_10.1371_journal.pone.0278337` fits into the existing `registry` + `replicateEverything` + Shiny stack with **minimal changes**.

## Design principle

| Layer | Responsibility |
|-------|----------------|
| **Study package** (`rep_*`) | Data, prep, analysis functions, tests, precomputed `inst/report/artifacts/` |
| **Registry** (`registry/`) | Index only: DOI, title, authors, pointer to package repo |
| **replicateEverything** | Install/load study package, dispatch `run_replication()` / `load_artifact()` |
| **Shiny** | Unchanged UI; calls replicateEverything as today |

Replication code **does not** live under `registry/papers/` anymore for this study.

## replication.yml contract (study package root)

The study package ships `replication.yml` (copied to `inst/replication.yml` for `system.file()`).

New fields compared to registry papers:

```yaml
paper:
  package: rep1371journalpone0278337   # R package name
repo: replicate-anything/rep_10.1371_journal.pone.0278337

prep:                                 # optional prep steps (Shiny "Run" buttons)
  - id: prep_data
    code: prep_data
    ...

replications:
  - id: fig_1
    make: make_figure_1
    format: format_figure_1
    data: wave4_conjoint
    artifact: inst/report/artifacts/fig_1.png
```

Registry `index.csv` row for this study becomes:

```csv
folder,doi,title,journal,year,authors,repo
10.1371_journal.pone.0278337,https://doi.org/10.1371/journal.pone.0278337,...,replicate-anything/rep_10.1371_journal.pone.0278337
```

`index.qmd` should read `paper$package` and `repo` from each study's `replication.yml` (whether in registry or fetched from the package repo).

## Minimal replicateEverything changes

### 1. Detect package-backed studies

In `get_replication_meta()` / `paper_context()`:

```r
# If meta$paper$package is set:
#   - repo points to package GitHub slug (not registry/papers/...)
#   - base_url is not used for code/data
#   - ensure_package(meta$paper$package, repo)
```

### 2. New helper: `ensure_replication_package()`

```r
ensure_replication_package <- function(package, repo) {
  if (!requireNamespace(package, quietly = TRUE)) {
    remotes::install_github(repo, upgrade = "ask")
  }
  invisible(TRUE)
}
```

### 3. Dispatch in `list_replications()` and `render_replication()`

```r
if (!is.null(meta$paper$package)) {
  pkg <- meta$paper$package
  ensure_replication_package(pkg, ctx$repo)
  return(get("list_replications", asNamespace(pkg))())
}

# render:
obj <- get("run_replication", asNamespace(pkg))(what, install_deps = install_deps)
```

### 4. Artifacts from package

```r
load_artifact <- function(doi, what, ...) {
  meta <- get_replication_meta(doi, ...)
  if (!is.null(meta$paper$package)) {
    pkg <- meta$paper$package
    return(get("load_artifact", asNamespace(pkg))(what))
  }
  # existing registry/papers/... path logic
}
```

### 5. Optional: `format_for_display()` passthrough

Package `run_replication()` already applies `format_*`. Shiny can treat returned HTML/ggplot as display-ready when `source = "package"`.

## Minimal Shiny changes

**None required** if replicateEverything API stays stable:

- `list_replications(doi)` still returns replication list
- `load_artifact(doi, what)` still works
- `render_for_display(doi, what)` still works

Optional UX: show **prep** steps from `meta$prep` as buttons before tables/figures (vaccine solidarity: `prep_data`, `prep_data_tab_2`).

## Registry CI changes

1. Stop expecting `registry/papers/10.1371_journal.pone.0278337/code/` for this study.
2. Registry index (`index.csv`) is built from `replication.yml` stubs via `index.qmd` (or stays in sync when that Quarto doc is rendered).
3. Artifact validation: run `rep1371journalpone0278337::build_report()` in package CI; registry checks `inst/report/manifest.json` exists on package release tag.

## Migration path for other studies

1. Create `rep_<doi-encoding>/` beside monorepo root.
2. Move code/data from `registry/papers/<folder>/` into package.
3. Update registry index row `repo` column.
4. Remove `registry/papers/<folder>/` once package is published.

## Current status

- [x] Study package scaffolded at `rep_10.1371_journal.pone.0278337/`
- [x] `replication.yml` with prep + 8 figures + 2 tables
- [x] Package API: `list_replications()`, `run_replication()`, `load_artifact()`, `build_report()`
- [ ] Wire `replicateEverything` dispatch (see section above)
- [ ] Update registry index row to point at package repo
- [ ] Remove duplicate `registry/papers/10.1371_journal.pone.0278337/` after cutover
