FROM rocker/r-ver:4.4.0

# DeGAUSS container metadata
ENV degauss_name="narr"
ENV degauss_version="1.0.0"
ENV degauss_description="daily weather data (temperature, humidity, etc)"
ENV degauss_argument="NARR variables to be returned (weather, wind, atmosphere, or precippres) [default: weather]"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

RUN R --quiet -e "install.packages('renv')"

WORKDIR /app

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libproj-dev \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev
    && apt-get clean

COPY renv.lock .

# Disable renv cache
ENV RENV_CONFIG_CACHE_ENABLED FALSE

RUN R --quiet -e "renv::restore(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest'))"

COPY entrypoint.R .

WORKDIR /tmp

ENTRYPOINT ["/app/entrypoint.R"]
