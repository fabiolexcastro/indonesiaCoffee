

# Load libraries ----------------------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, plotKML, readxl)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Clean dataframe ---------------------------------------------------------------------
cleanTbl <- function(pos){
  d <- gp2[[pos]] %>% 
    dplyr::select(lon, lat) %>% 
    mutate(name = basename(fls[pos]))
}

# Load data ---------------------------------------------------------------------------
fls <- list.files('../gpx', pattern = 'gpx', full.names = TRUE)
gps <- lapply(fls, readGPX, waypoints = TRUE, track = FALSE, routes = FALSE)
gp2 <- list()

# Ciclo to extract the waypoints only --------------------------------------------------
for (i in 1:length(gps)){
  gp2[[i]] <- gps[[i]]$waypoints
}

gp2 <- map(.x = gp2, .f = as_tibble)
gp2 <- map(.x = 1:2, .f = cleanTbl)
ara <- gp2[[1]] %>% 
  mutate(Specie = 'arabica')
rob <- gp2[[2]] %>% 
  mutate(Specie = 'robusta')

tbl <- rbind(ara, rob)
write.csv(tbl, '../tbl/occ/ara_rob_gps.csv', row.names = FALSE)

# Farmer GPS Robusta
tbl <- read_excel('../gpx/Farmer GPS Robusta.xlsx') %>% 
  dplyr::select(longitude, latitude) %>% 
  mutate(country = 'Indonesia',
         Species = 'Robusta', 
         Source = 'Danu Witoko')
write.csv(tbl, '../tbl/occ/farmer_gps_robusta.csv', row.names = FALSE)


