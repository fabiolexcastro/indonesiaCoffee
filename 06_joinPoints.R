

# Load libraries -----------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, plotKML, magrittr)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------
pnt <- read_csv('W:/_points/_global/Presence_data_all_2019_july_v3.csv')
pnt %<>% 
  filter(Country == 'Indonesia') 

# Arabica -----------
ara <- pnt %>% 
  filter(Country == 'Indonesia' &
           Species %in% c('arabica', 'Coffea_arabica')) %>% 
  mutate(Species = 'arabica')

# Robusta  
rob <- pnt %>% 
  filter(Country == 'Indonesia' &
           Species %in% c('robusta', 'Robusta')) %>% 
  mutate(Species = 'robusta')

unique(rob$Source)

cf1 <- rbind(ara, rob)
colnames(cf1)

# Other files -------------------------------------------------------------
gps <- read_csv('../tbl/occ/ara_rob_gps.csv')
dtv <- read_csv('../tbl/occ/arabica_dataverse.csv')
rob <- read_csv('../tbl/occ/farmer_gps_robusta.csv')

unique(gps$Species)

gps <- gps %>% 
  transmute(Id = 1:nrow(.),
            Species = Specie,
            Longitude = lon, 
            Latitude = lat,
            Altitude = NA,
            Country = 'Indonesia', 
            Year = 2019,
            Source = 'Arabica Aceh and North Sumatera')

dtv <- dtv %>% 
  transmute(Id = 1:nrow(.),
            Species = 'arabica',
            Longitude = Longitude, 
            Latitude = Latitude,
            Altitude = NA,
            Country = 'Indonesia', 
            Year = 2019,
            Source = Source)

rob <- rob %>% 
  transmute(Id = 1:nrow(.),
            Species = 'robusta',
            Longitude = longitude, 
            Latitude = latitude,
            Altitude = NA,
            Country = 'Indonesia', 
            Year = 2019,
            Source = Source)
  
cf2 <- rbind(gps, dtv, rob)

cff <- rbind(cf1, cf2)
write.csv(cff, '../tbl/occ/cff_all.csv', row.names = FALSE)

