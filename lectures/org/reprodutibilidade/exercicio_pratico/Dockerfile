FROM jupyter/r-notebook

RUN Rscript -e 'install.packages("devtools", repos="https://cran.rstudio.com")'
RUN Rscript -e 'library(devtools);install_version("datasauRus", version="0.1.4", repos = "http://cran.us.r-project.org")'
