FROM rocker/r-ver:4.0.5

# DeGAUSS container metadata
ENV degauss_name="narr"
ENV degauss_version="0.4.0"
ENV degauss_description="daily weather data (temperature, humidity, etc)"
ENV degauss_argument="NARR variables to be returned (weather, wind, atmosphere, pratepres, or none) [default: weather]"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

RUN R --quiet -e "install.packages('remotes', repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"

RUN R --quiet -e "remotes::install_github('rstudio/renv@0.15.4')"

WORKDIR /app

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libproj-dev \
    && apt-get clean

COPY renv.lock .

RUN R --quiet -e "renv::restore(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest', other = 'https://cran.rstudio.com'))"

COPY entrypoint.R .

WORKDIR /tmp

ENTRYPOINT ["/app/entrypoint.R"]
