FROM --platform=linux/amd64 rocker/verse:4.4.1
RUN apt-get update && apt-get install -y  libcairo2-dev libcurl4-openssl-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libicu-dev libjpeg-dev libpng-dev libssl-dev libtiff-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("bslib",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.5.1")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.23")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("waiter",upgrade="never", version = "0.2.5")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("shinyBS",upgrade="never", version = "0.61.1")'
RUN Rscript -e 'remotes::install_version("nftbart",upgrade="never", version = "2.1")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.4.1")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.4.3")'
RUN Rscript -e 'remotes::install_version("flextable",upgrade="never", version = "0.9.6")'
RUN Rscript -e 'remotes::install_version("fastDummies",upgrade="never", version = "1.7.3")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.33")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 80
ENV RDS_DATA /efsdata

CMD R -e "remotes::install_local(upgrade=\"never\");options('shiny.port'=80,shiny.host='0.0.0.0');library(nmdp.asom);nmdp.asom::run_app()"
