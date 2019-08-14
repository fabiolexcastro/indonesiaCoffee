
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse)

g <- gc(RESET = true)
rm(list = ls())
options(scipen = 999)

vrs <- c(paste0('prec_', 1:12), paste0('tmax_', 1:12), paste0('tmean_', 1:12), paste0('tmin_', 1:12), paste0('bio_', 1:19))
vrs <- paste0(vrs, '$')

# Load data ---------------------------------------------------------------
pth <- '//dapadfs/data_cluster_4/observed/gridded_products/worldclim/Global_30s_v2/_grid'
fls <- list.files(pth, full.names = TRUE) %>% 
  grep(paste0(vrs, collapse = '|'), ., value = TRUE)
ind <- raster::getData('GADM', country = 'IDN', level = 0)

# Current
crn <- stack(fls)
crn <- raster::crop(crn, ind) %>% raster::mask(ind)

