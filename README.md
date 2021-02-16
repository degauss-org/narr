# narr <a href='https://degauss-org.github.io/DeGAUSS/'><img src='https://github.com/degauss-org/degauss_template/blob/master/DeGAUSS_hex.png' align='right' height='138.5' /></a>

> short description of geomarker

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/narr)](https://hub.docker.com/repository/docker/degauss/narr/tags)
[![GitHub Latest Tag](https://img.shields.io/github/v/tag/degauss-org/narr)](https://github.com/degauss-org/narr/releases)

## DeGAUSS example call

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon` and date columns named `start_date` and `end_date`, then

```sh
docker run --rm -v $PWD:/tmp degauss/narr:0.1 my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_narr_v0.1.csv` with an added column named narr.

## narr.fst

To use this container, the user must have [`narr.fst`](s3://geomarker/narr/narr.fst) in their working directory. If `narr.fst` is not present, the user will be prompted to download it. The file is large file to download (> 22 GB), but will only need to be done once per user and computer.

## geomarker methods

This container was built using the [addNarrData](https://github.com/geomarker-io/addNarrData) package. 

## geomarker data

- Daily weather data was downloaded from [NARR](https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/north-american-regional-reanalysis-narr). 
- NARR data is stored as an [fst](https://github.com/fstpackage/fst) file at s3://geomarker/narr/narr.fst.

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
