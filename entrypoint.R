#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))
withr::with_message_sink("/dev/null", library(sf))
withr::with_message_sink("/dev/null", library(data.table))
withr::with_message_sink("/dev/null", library(addNarrData))

doc <- '
      Usage:
      narr.R <filename>
      narr.R <filename> --all
      narr.R (-h | --help)

      Options:
      -h --help   Show this screen
      --all   Returns all narr variables
      '

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

message("reading input file...")
d <- dht::read_lat_lon_csv(opt$filename)

dht::check_for_column(d, "lat", d$lat)
dht::check_for_column(d, "lon", d$lon)
dht::check_for_column(d, 'start_date', d$start_date)
dht::check_for_column(d, 'end_date', d$end_date)

d$start_date <- dht::check_dates(d$start_date)
d$end_date <- dht::check_dates(d$end_date)

## add code here to calculate geomarkers
message('appending NARR variables based on grid cell and date range...')
if (!opt$all) {
  d_out <- addNarrData::get_narr_data(d, narr_variables = c("air.2m", "rhum.2m"), confirm = F)
  arg_file_name <- ""
} else {
  cli::cli_alert_warning("Due to their size, the narr data files will be downloaded and processed in 4 groups of 2,
                         which will be reflected in the progress messages below.")
  d_out1 <- addNarrData::get_narr_data(d, narr_variables = c("hpbl", "vis"), confirm = F)
  d_out2 <- addNarrData::get_narr_data(d, narr_variables = c("uwnd.10m", "vwnd.10m"), confirm = F)
  d_out3 <- addNarrData::get_narr_data(d, narr_variables = c("air.2m", "rhum.2m"), confirm = F)
  d_out4 <- addNarrData::get_narr_data(d, narr_variables = c("prate", "pres.sfc"), confirm = F)

  suppressMessages(
    d_out <- left_join(d_out1, d_out2) %>%
      left_join(d_out3) %>%
      left_join(d_out4) %>%
      select(-.row)
  )

  arg_file_name <- "all_vars"
}

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d_out,
                          filename = opt$filename,
                          argument = arg_file_name)


