# rep_10.1371_journal.pone.0278337

Self-contained R replication package for:

> Geissler, Hartmann, Humphreys, Klüver, and Giesecke (2022). *Public support for global vaccine sharing in the COVID-19 pandemic: Evidence from Germany.* PLOS ONE. [doi:10.1371/journal.pone.0278337](https://doi.org/10.1371/journal.pone.0278337)

Source analysis repository: [wzb-ipi/vaccine_solidarity](https://github.com/wzb-ipi/vaccine_solidarity)

## Layout

```
rep_10.1371_journal.pone.0278337/
  replication.yml          # edit here; copied to inst/ by sync script
  data/                    # wave4_conjoint, wave2_survey, vignette_labels (.rda)
  data-raw/                # CSV sources + build/sync scripts
  R/                       # canonical package source (edit these files)
    helpers.R              # shared helpers
    prep_data.R            # rebuild analysis data from combined.csv
    prep_data_tab_2.R      # conjoint reshape for Table 2
    make_figure_*.R        # figure builders
    make_table_*.R         # table builders
    format_outputs.R       # display formatters
    replication_code.R     # get_code() for Shiny Code tab
    replication_api.R      # list_replications(), run_replication(), load_artifact()
    build_report.R         # write inst/report/artifacts/*
  inst/
    replication.yml        # installed copy (do not edit by hand)
    replication_code/      # installed copies of make_*/prep_*/format_outputs.R
    report/artifacts/        # precomputed outputs for Shiny Display
```

### R/ vs inst/replication_code/

`R/` is the **only place to edit** analysis code. Files under `inst/replication_code/` are **generated copies** so `get_code()` can show source after `R CMD INSTALL` (installed packages do not ship `R/`). Regenerate with:

```bash
Rscript data-raw/sync_replication_code.R
```

Run this after changing any `make_*`, `prep_data*`, or `format_outputs.R`, and before release. A test checks the copies stay in sync.

`inst/replication.yml` is synced the same way from the package-root `replication.yml`.

## Quick start

```r
# from monorepo root
devtools::install("rep_10.1371_journal.pone.0278337")

library(rep1371journalpone0278337)
list_replications()
make_figure_1()
make_table_1()
```

`build_report()` is only for **package release / CI** — it writes precomputed PNG/HTML into `inst/report/artifacts/` so published installs serve fast Display. Shiny runs replications live when artifacts are absent, so you do not need this to use the app locally.

### Replication vignette (Quarto)

The main analysis is in `vignettes/vaccine-solidarity-replication.qmd` (mirrors
`vaccine_solidarity/analysis.Rmd` using one `make_*` script per figure/table).
Render locally:

```bash
quarto render vignettes/vaccine-solidarity-replication.qmd
```

For a full HTML site including the vignette, run `build_report()` first (optional,
for table display), then `pkgdown::build_site()`. Table chunks are `eval: false`
by default so you can step through the slow structural fit manually.

## Data

Package data are built from CSV sources in `data-raw/`:

```bash
Rscript data-raw/build_package_data.R
Rscript data-raw/sync_replication_code.R
```

To rebuild from raw survey export (requires `combined.csv` from vaccine_solidarity):

```r
prep_data("path/to/combined.csv")
```

## Tests

```r
devtools::test("rep_10.1371_journal.pone.0278337")
```

## Registry integration

See `INTEGRATION.md`. Registry stub YAML uses:

- `paper.package_folder` — sibling folder name for local/monorepo use
- `paper.package_repo` — GitHub slug for online install once published
