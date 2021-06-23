# narr <a href='https://degauss-org.github.io/DeGAUSS/'><img src='https://github.com/degauss-org/degauss_template/blob/master/DeGAUSS_hex.png' align='right' height='138.5' /></a>

> add NARR weather variables to geocoded data

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/narr)](https://hub.docker.com/repository/docker/degauss/narr/tags)
[![GitHub Latest Tag](https://img.shields.io/github/v/tag/degauss-org/narr)](https://github.com/degauss-org/narr/releases)

## DeGAUSS example call

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon` and date columns named `start_date` and `end_date`, then

```sh
docker run --rm -v $PWD:/tmp degauss/narr:0.2 my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_narr_v0.2.csv` with an added columns named `air.2m` and `rhum.2m`.

Only air temperature and humidity are added by default. To add all NARR variables, append `--all` to the end of the docker call above. 

NARR Data Dictionary

| Variable Name | Description                     |
|:--------------|:--------------------------------|
| **air.2m**        | Air Temperature at 2m           |
| **rhum.2m**       | Humidity at 2m                  |
| hpbl          | Planetary Boundary Layer Height |
| vis           | Visibility                      |
| uwnd.10m      | U Wind Speed at 10m             |
| vwnd.10m      | V Wind Speed at 10m             |
| prate         | Precipitation Rate              |
| pres.sfc      | Surface Pressure                |

## geomarker methods

This container was built using the [addNarrData](https://github.com/geomarker-io/addNarrData) package.

## geomarker data

- Daily weather data was downloaded from [NARR](https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/north-american-regional-reanalysis-narr). 
- NARR data is stored as an [fst](https://github.com/fstpackage/fst) file at [s3://geomarker/narr/narr.fst](s3://geomarker/narr/narr.fst).
- Detailed information for how data was converted to chunk files can be found [here](https://github.com/geomarker-io/narr_raster_to_fst).

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
