#!/usr/local/bin/Rscript

dht::greeting(geomarker_name = 'narr', version = '0.2', description = 'add NARR weather variables to geocoded data')

dht::qlibrary(dplyr)
dht::qlibrary(tidyr)
dht::qlibrary(sf)

doc <- '
      Usage:
      narr.R <filename>
      '

opt <- docopt::docopt(doc)
## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

d <- dht::read_lat_lon_csv(opt$filename)

dht::check_for_column(d, 'lat', d$lat)
dht::check_for_column(d, 'lon', d$lon)
dht::check_for_column(d, 'start_date', d$start_date)
dht::check_for_column(d, 'end_date', d$end_date)

d$start_date <- dht::check_dates(d$start_date)
d$end_date <- dht::check_dates(d$end_date)

message('appending NARR variables based on grid cell and date range...')
d_out <- addNarrData::get_narr_data(d, confirm = F)

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d_out,
                     filename = opt$filename,
                     geomarker_name = 'narr',
                     version = '0.2')


