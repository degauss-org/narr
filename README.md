# narr <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/narr?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/narr/releases)
[![container build status](https://github.com/degauss-org/narr/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/narr/actions/workflows/build-deploy-release.yaml)

## Using

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat`, `lon`, `start_date`, and `end_date` then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/narr:0.4.0 my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_narr_0.4.0.csv` with added columns:

- **`air.2m`**: air temperature at 2m
- **`rhum.2m`**: humidity at 2m

### Optional Argument

By default, only `air.2m` and `rhum.2m` are returned. Using the `--all` flag as shown below

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/narr:0.4.0 my_address_file_geocoded.csv --all
```

will also return the following NARR variables.

- **`hpbl`**: planetary boundary layer height
- **`vis`**: visibility
- **`uwnd.10m`**: U wind speed at 10mt
- **`vwnd.10m`**: V wind speed at 10m
- **`prate`**: precipitation rate
- **`pres.sfc`**: surface pressure

### Docker RAM requirements

If this container errors unexpectedly, you may need to allocate more RAM to Docker. Please see the [troubleshooting guide](https://degauss.org/troubleshooting.html#Insufficient_Memory) for more information.

## Geomarker Methods

This container was built using the [addNarrData](https://geomarker.io/addNarrData/) package.

## Geomarker Data

- Daily weather data was downloaded from [NARR](https://www.ncei.noaa.gov/products/weather-climate-models/north-american-regional).
- NARR data is stored as [fst](https://github.com/fstpackage/fst) files at s3://geomarker/narr/narr_chunk_fst/.
- Detailed information for how data was converted to chunk files can be found [here](https://github.com/geomarker-io/narr_raster_to_fst).

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
