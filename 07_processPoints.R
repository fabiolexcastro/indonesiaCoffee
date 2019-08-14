


# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, plotKML, magrittr)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Functions to use --------------------------------------------------------
dup_cell <- function(mask, df){
  num <- raster::extract(mask, df[,c('Longitude', 'Latitude')], cellnumbers = T) 
  cls <- xyFromCell(mask, num[,'cells'])
  dup <- duplicated(cls[,c('x', 'y')])
  rmv <- tbl_df(df[!dup,])
  dup <- tbl_df(df[dup,])
  print('Done!')
  return(list(rmv, dup))
}

# Load data ---------------------------------------------------------------
tbl <- read_csv('../tbl/occ/cff_all.csv')
ind <- raster::getData('GADM', country = 'IDN', level = 1)
msk <- raster('../raster/tif/bse/mask.tif')

# Filtering for each Specie
unique(tbl$Species)
rob <- tbl %>%
  filter(Species == 'robusta')
ara <- tbl %>%
  filter(Species == 'arabica')

rob %>% 
  distinct(Source)

# Aplying duplicate by cell -----------------------------------------------
rob_dup <- dup_cell(mask = msk, df = rob)[[1]]
ara_dup <- dup_cell(mask = msk, df = ara)[[1]]

write.csv(rob_dup, '../tbl/occ/robusta_dup.csv', row.names = FALSE)
write.csv(ara_dup, '../tbl/occ/arabica_dup.csv', row.names = FALSE)

# Table to shapefile ------------------------------------------------------
coordinates(rob_dup) <- ~ Longitude + Latitude
coordinates(ara_dup) <- ~ Longitude + Latitude

writeOGR(obj = rob_dup, dsn = '../shp/occ', layer = 'robusta_dup', driver = 'ESRI Shapefile', overwrite_layer = TRUE)
writeOGR(obj = ara_dup, dsn = '../shp/occ', layer = 'arabica_dup', driver = 'ESRI Shapefile', overwrite_layer = TRUE)

# Summarizing -------------------------------------------------------------
rob_dup %>% 
  as.data.frame %>% 
  as_tibble %>% 
  distinct(Source) %>% 
  pull()

ara_dup %>% 
  as.data.frame %>% 
  as_tibble %>% 
  distinct(Source) %>% 
  pull()

smm_rob <- raster::extract(ind, rob_dup) %>% 
  dplyr::select(NAME_0, NAME_1) %>% 
  group_by(NAME_1) %>% 
  dplyr::summarise(count = n())

smm_ara <- raster::extract(ind, ara_dup) %>% 
  dplyr::select(NAME_0, NAME_1) %>% 
  group_by(NAME_1) %>% 
  dplyr::summarise(count = n())


write.csv(smm_ara, '../tbl/occ/arabica_dup_smm.csv', row.names = FALSE)
write.csv(smm_rob, '../tbl/occ/robusta_dup_smm.csv', row.names = FALSE)


