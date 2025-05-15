#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))
withr::with_message_sink("/dev/null", library(sf))
withr::with_message_sink("/dev/null", library(dht))

doc <- '
      Usage:
      narr.R <filename> [<vars>]
      narr.R (-h | --help)

      Options:
      -h --help   Show this screen
      filename  name of csv file
      vars   weather, wind, atmosphere, or precippres (see readme for more info)
      '

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')
d <- dht::read_lat_lon_csv(opt$filename)

# checks
dht::check_for_column(d, "lat", d$lat)
dht::check_for_column(d, "lon", d$lon)
dht::check_for_column(d, 'start_date', d$start_date)
dht::check_for_column(d, 'end_date', d$end_date)
d$start_date <- dht::check_dates(d$start_date)
d$end_date <- dht::check_dates(d$end_date)
dht::check_end_after_start_date(d$start_date, d$end_date)

if (is.null(opt$vars)) opt$vars <- "null"
if (!opt$vars %in% c("weather", "wind", "atmosphere", "precippres")) {
  opt$vars <- "weather"
  cli::cli_alert_warning(
    "Blank or invalid argument for NARR variable selection. Will return air.2m and rhum.2m. Please see {.url https://degauss.org/narr/} for more information about the NARR variable argument."
  )
}

narr_variables = case_when(
  opt$vars == "weather" ~ c("air.2m", "rhum.2m"),
  opt$vars == "wind" ~ c("uwnd.10m", "vwnd.10m"),
  opt$vars == "atmosphere" ~ c("hpbl", "vis"),
  opt$vars == "precippres" ~ c("acpcp", "pres.sfc")
)

message('linking to s2 cells...')
options(timeout = 3600)
d_s2 <-
  d |>
  mutate(s2 = s2::s2_lnglat(d$lon, d$lat) |> s2::as_s2_cell()) |>
  filter(!is.na(s2)) |>
  mutate(
    dates = purrr::map2(
      start_date,
      end_date,
      \(x, y) seq.Date(from = x, to = y, by = "day")
    )
  )

d_narr <-
  purrr::map(
    narr_variables,
    \(narr_var)
      d_s2 |>
        mutate(
          {{ narr_var }} := appc::get_narr_data(
            x = s2,
            dates = dates,
            narr_var = narr_var
          )
        )
  ) |>
  purrr::reduce(.f = left_join) |>
  tidyr::unnest(c(dates, all_of(narr_variables))) |>
  select(.row = .row, dates, all_of(narr_variables))

d_out <- left_join(d, d_narr, by = ".row")

dht::write_geomarker_file(
  d = d_out,
  filename = opt$filename,
  argument = opt$vars
)
