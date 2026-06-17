# rep_10.1371_journal.pone.0278337

Self-contained R replication package for:

> Geissler, Hartmann, Humphreys, Klüver, and Giesecke (2022). *Public support for global vaccine sharing in the COVID-19 pandemic: Evidence from Germany.* PLOS ONE. [doi:10.1371/journal.pone.0278337](https://doi.org/10.1371/journal.pone.0278337)

Source analysis repository: [wzb-ipi/vaccine_solidarity](https://github.com/wzb-ipi/vaccine_solidarity)

## Layout

```
rep_10.1371_journal.pone.0278337/
  replication.yml          # registry metadata (also in inst/)
  data/                    # wave4_conjoint, wave2_survey, vignette_labels
  R/
    helpers.R              # shared helpers
    prep_data.R            # rebuild analysis data from combined.csv
    prep_data_tab_2.R      # conjoint reshape for Table 2
    make_figure_*.R        # analysis + display for each figure
    make_table_*.R         # analysis for each table
    format_outputs.R       # display formatters
    build_report.R         # write inst/report/artifacts/*
    replication_api.R      # list_replications(), run_replication(), load_artifact()
  inst/report/artifacts/   # precomputed outputs for Shiny Display
```

## Quick start

```r
# from monorepo root
devtools::install("rep_10.1371_journal.pone.0278337")

library(rep1371journalpone0278337)
list_replications()
make_figure_1()
make_table_1()
build_report()   # regenerate inst/report/artifacts/
```

## Data

Package data are built from CSV sources in `data-raw/`:

```bash
Rscript data-raw/build_package_data.R
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
